module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;

    // Combinational logic for next state calculation
    always @(*) begin
        for (integer i = 0; i < 16; i = i + 1) begin
            for (integer j = 0; j < 16; j = j + 1) begin
                integer idx = i*16 + j;
                integer count = 0;
                
                // Calculate neighbor positions with wrap-around
                integer row_p = (i == 0) ? 15 : i - 1;
                integer row_n = (i == 15) ? 0 : i + 1;
                integer col_p = (j == 0) ? 15 : j - 1;
                integer col_n = (j == 15) ? 0 : j + 1;
                
                // Count all 8 neighbors
                count = count + q[row_p*16 + col_p];
                count = count + q[row_p*16 + j];
                count = count + q[row_p*16 + col_n];
                count = count + q[i*16 + col_p];
                count = count + q[i*16 + col_n];
                count = count + q[row_n*16 + col_p];
                count = count + q[row_n*16 + j];
                count = count + q[row_n*16 + col_n];
                
                // Apply game rules
                case (count)
                    2: next_q[idx] = q[idx];  // No change
                    3: next_q[idx] = 1'b1;    // Birth
                    default: next_q[idx] = 1'b0; // Death
                endcase
            end
        end
    end

    // Sequential state update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule