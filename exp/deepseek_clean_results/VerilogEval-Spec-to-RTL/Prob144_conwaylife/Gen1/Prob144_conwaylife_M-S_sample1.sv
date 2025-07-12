module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] next_q;
    integer i, row, col;
    integer n_row, n_col, n_idx;
    integer count;

    always @(*) begin
        for (i = 0; i < 256; i = i + 1) begin
            row = i / 16;
            col = i % 16;
            count = 0;

            // Check all 8 neighbors
            for (integer dr = -1; dr <= 1; dr = dr + 1) begin
                for (integer dc = -1; dc <= 1; dc = dc + 1) begin
                    if (dr == 0 && dc == 0) continue; // skip self
                    
                    // Toroidal neighbor calculation
                    n_row = (row + dr + 16) % 16;
                    n_col = (col + dc + 16) % 16;
                    n_idx = n_row * 16 + n_col;
                    
                    count = count + q[n_idx];
                end
            end

            // Apply transition rules
            case (count)
                0, 1: next_q[i] = 1'b0;
                2:    next_q[i] = q[i];
                3:    next_q[i] = 1'b1;
                default: next_q[i] = 1'b0;
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