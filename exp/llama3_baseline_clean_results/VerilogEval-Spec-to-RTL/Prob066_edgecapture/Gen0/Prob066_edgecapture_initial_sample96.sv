module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] prev_in; // Register to store the previous input vector
reg [31:0] out_reg; // Register to store the output vector

always @ (posedge clk) begin
    if (reset) begin // Active high synchronous reset
        out_reg <= 32'd0; // Clear the output vector on reset
    end else begin
        prev_in <= in; // Update the previous input vector
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] == 1 && in[i] == 0) begin // Check if the bit changes from 1 to 0
                out_reg[i] <= 1; // Set the corresponding bit in the output vector to 1
            end
        end
    end
end

assign out = out_reg; // Assign the output vector to the output port

endmodule