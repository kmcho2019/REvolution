module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    localparam SIZE = 16;

    integer i, n;
    reg [3:0] r, c;
    reg [3:0] nr, nc;
    reg [3:0] neighbor_count;
    reg current_cell;
    reg [255:0] next_q;

    // Wrap coordinates modulo 16 using 4-bit mask
    function [3:0] wrap16;
        input integer val;
        begin
            wrap16 = val[3:0]; // keep lower 4 bits for modulo 16 wraparound
        end
    endfunction

    // Compute neighbor count for a given cell index
    function [3:0] count_neighbors;
        input [255:0] grid;
        input [3:0] row;
        input [3:0] col;
        integer dr, dc;
        reg [3:0] count;
        reg [3:0] rr, cc;
        begin
            count = 0;
            for (dr = -1; dr <= 1; dr = dr + 1) begin
                for (dc = -1; dc <= 1; dc = dc + 1) begin
                    if (!(dr == 0 && dc == 0)) begin
                        rr = wrap16(row + dr);
                        cc = wrap16(col + dc);
                        count = count + grid[rr*SIZE + cc];
                    end
                end
            end
            count_neighbors = count;
        end
    endfunction

    always @* begin
        next_q = 256'd0;
        for (i = 0; i < 256; i = i + 1) begin
            r = i[7:4]; // row = upper 4 bits
            c = i[3:0]; // col = lower 4 bits
            current_cell = q[i];
            neighbor_count = count_neighbors(q, r, c);
            case (neighbor_count)
                2: next_q[i] = current_cell; // stay the same
                3: next_q[i] = 1'b1;          // become alive
                default: next_q[i] = 1'b0;    // otherwise die
            endcase
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule