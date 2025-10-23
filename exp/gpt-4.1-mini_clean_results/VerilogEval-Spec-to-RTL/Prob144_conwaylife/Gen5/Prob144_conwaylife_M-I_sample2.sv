module TopModule (
    input             clk,
    input             load,
    input      [255:0] data,
    output reg [255:0] q
);
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    // Stage 1: neighbor counts storage (4 bits per cell)
    reg [3:0] neighbor_counts [0:255];

    // Temporary variables for combinational neighbor count calculation
    integer r, c, dr, dc;
    integer nr, nc;
    integer idx_center;
    integer idx_neighbor;
    integer count;

    // Function to wrap indices modulo 16 using bitwise AND
    function [3:0] wrap16(input integer val);
        begin
            wrap16 = val & 4'hF;
        end
    endfunction

    // Stage 1: Compute neighbor counts combinationally every clock cycle
    // Implemented in an always block triggered by clock (next cycle load neighbors)
    // To reduce combinational complexity, compute counts sequentially across clock cycles
    // but since this is a single module, we compute all counts combinationally
    // then store in registers at posedge clk.

    reg [3:0] neighbor_counts_next [0:255];

    always @(*) begin
        for (r = 0; r < HEIGHT; r = r + 1) begin
            for (c = 0; c < WIDTH; c = c + 1) begin
                count = 0;
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        if (!(dr == 0 && dc == 0)) begin
                            nr = wrap16(r + dr);
                            nc = wrap16(c + dc);
                            idx_neighbor = (nr << 4) + nc;
                            count = count + q[idx_neighbor];
                        end
                    end
                end
                idx_center = (r << 4) + c;
                neighbor_counts_next[idx_center] = count[3:0];
            end
        end
    end

    // Stage 2: Update q from neighbor_counts registers
    // State machine and pipeline:
    // On load: q <= data, neighbor_counts <= 0
    // Else:
    //   neighbor_counts <= neighbor_counts_next (stage1)
    //   q <= next_q computed from neighbor_counts (stage2)

    // Compute next_q from neighbor_counts and current q stored registers
    reg [255:0] next_q;

    always @(*) begin
        for (r = 0; r < HEIGHT; r = r + 1) begin
            for (c = 0; c < WIDTH; c = c + 1) begin
                idx_center = (r << 4) + c;
                case (neighbor_counts[idx_center])
                    4'd0, 4'd1: next_q[idx_center] = 1'b0;
                    4'd2:       next_q[idx_center] = q[idx_center];
                    4'd3:       next_q[idx_center] = 1'b1;
                    default:    next_q[idx_center] = 1'b0;
                endcase
            end
        end
    end

    // Sequential logic pipeline
    // On clock edge:
    //   if load asserted: load q with data, reset neighbor_counts to 0
    //   else: update neighbor_counts <= neighbor_counts_next (computed from q)
    //         update q <= next_q (computed from neighbor_counts)
    integer i;
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            for (i = 0; i < 256; i = i + 1)
                neighbor_counts[i] <= 4'd0;
        end else begin
            // neighbor_counts updated first stage pipeline
            for (i = 0; i < 256; i = i + 1)
                neighbor_counts[i] <= neighbor_counts_next[i];
            // q updated from previous neighbor_counts stage
            q <= next_q;
        end
    end

endmodule