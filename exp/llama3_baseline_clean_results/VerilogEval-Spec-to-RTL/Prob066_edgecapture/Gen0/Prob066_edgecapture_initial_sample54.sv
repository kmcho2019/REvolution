module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] prev_in; // Register to store previous state of input vector
reg [31:0] out_reg; // Register to store output vector

always @(posedge clk) begin
    if (reset) begin // Active high synchronous reset
        out_reg <= 32'b0; // Reset output vector
    end else begin
        for (int i = 0; i < 32; i++) begin // Loop through each bit in the input vector
            if (prev_in[i] == 1'b1 && in[i] == 1'b0) begin // Check if bit has changed from 1 to 0
                out_reg[i] <= 1'b1; // Set corresponding bit in output vector
            end
        end
        prev_in <= in; // Update previous state of input vector
    end
end

assign out = out_reg; // Assign output vector to output port

endmodule