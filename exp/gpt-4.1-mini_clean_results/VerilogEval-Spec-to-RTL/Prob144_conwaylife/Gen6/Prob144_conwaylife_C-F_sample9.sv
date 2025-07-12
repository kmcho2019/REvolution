module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    localparam SIZE = 16;
    localparam MASK = 4'hF;  // For modulo 16 wrap-around via bitmasking

    reg [255:0] next_q;

    integer i, ni, nj;
    reg [3:0] r, c;
    reg [3:0] nr, nc;
    integer neighbor_count;
    reg current_cell_state;
    integer idx_neighbor;

    always @* begin
        for (i = 0; i < 256; i = i + 1) begin
            // Extract row and column from index i
            r = i[7:4];
            c = i[3:0];

            neighbor_count = 0;
            current_cell_state = q[i];

            // Check all 8 neighbors with wrapping
            for (ni = -1; ni <= 1; ni = ni + 1) begin
                for (nj = -1; nj <= 1; nj = nj + 1) begin
                    if (!(ni == 0 && nj == 0)) begin
                        nr = (r + ni) & MASK;
                        nc = (c + nj) & MASK;

                        idx_neighbor = {nr, nc};
                        neighbor_count = neighbor_count + q[idx_neighbor];
                    end
                end
            end

            // Apply game rules for next cell state
            case (neighbor_count)
                2: next_q[i] = current_cell_state;
                3: next_q[i] = 1'b1;
                default: next_q[i] = 1'b0;
            endcase
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule