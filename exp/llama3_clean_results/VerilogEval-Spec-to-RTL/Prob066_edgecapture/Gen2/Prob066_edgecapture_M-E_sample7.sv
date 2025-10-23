module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] state; // State register to track the state of each bit
reg [31:0] out_reg; // Output register

always @(posedge clk) begin
    if (reset) begin
        // Reset the state and output registers
        state <= 32'b0;
        out_reg <= 32'b0;
    end else begin
        // Update the state register
        state <= in;
        
        // Update the output register
        for (int i = 0; i < 32; i++) begin
            if (in[i] == 1'b0 && state[i] == 1'b1) begin
                out_reg[i] <= 1'b1;
            end
        end
    end
end

// Assign the output of the module to the output register
assign out = out_reg;

endmodule