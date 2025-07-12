module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] prev_in; // Register to store the previous input state
reg [31:0] out_reg; // Output register

always @(posedge clk) begin
    if (reset) begin
        // Reset the output register and previous input state
        out_reg <= 32'b0;
        prev_in <= 32'b0;
    end else begin
        // Update the previous input state
        prev_in <= in;
        
        // Detect transitions from 1 to 0 and update the output register
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] && !in[i]) begin
                out_reg[i] <= 1'b1;
            end else if (out_reg[i]) begin
                // If already set, keep it set unless reset
                out_reg[i] <= out_reg[i];
            end
        end
    end
end

// Assign the output of the module to the output register
assign out = out_reg;

endmodule