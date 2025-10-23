module counter_12(
    input rst_n, // Reset signal (active low)
    input clk,   // Clock signal
    input valid_count, // Signal to enable counting
    output [3:0] out  // 4-bit output representing the current count value
);

reg [3:0] out_reg; // internal register to store the count value

// assign output to internal register
assign out = out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin // asynchronous reset
        out_reg <= 4'b0000;
    end else if (valid_count) begin // valid_count is high
        if (out_reg == 4'd11) begin // check if count has reached maximum value
            out_reg <= 4'b0000; // wrap around to 0
        end else begin
            out_reg <= out_reg + 1; // increment count
        end
    end
end

endmodule