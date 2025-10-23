module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (integer i = 0; i < 16; i = i + 1) begin
                for (integer j = 0; j < 16; j = j + 1) begin
                    // Calculate neighbor positions with wrap-around
                    integer row_prev = (i == 0) ? 15 : (i - 1);
                    integer row_next = (i == 15) ? 0 : (i + 1);
                    integer col_prev = (j == 0) ? 15 : (j - 1);
                    integer col_next = (j == 15) ? 0 : (j + 1);
                    
                    // Count live neighbors
                    integer count = 
                        q[row_prev*16 + col_prev] + q[row_prev*16 + j] + q[row_prev*16 + col_next] +
                        q[i*16 + col_prev] + q[i*16 + col_next] +
                        q[row_next*16 + col_prev] + q[row_next*16 + j] + q[row_next*16 + col_next];
                    
                    // Apply game rules
                    case (count)
                        2: q[i*16 + j] <= q[i*16 + j];  // No change
                        3: q[i*16 + j] <= 1'b1;         // Birth/survival
                        default: q[i*16 + j] <= 1'b0;   // Death
                    endcase
                end
            end
        end
    end

endmodule