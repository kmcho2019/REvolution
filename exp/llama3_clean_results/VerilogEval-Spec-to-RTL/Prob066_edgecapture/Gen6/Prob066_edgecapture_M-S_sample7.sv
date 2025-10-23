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
        // Reset the output register
        out_reg <= 32'b0;
    end else begin
        // Detect transitions from 1 to 0 and update the output register
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] &&!in[i]) begin
                out_reg[i] <= 1'b1;
            end
        end
    end
end

// Update the previous input state
always @(posedge clk) begin
    prev_in <= in;
end

// Assign the output of the module to the output register
assign out = out_reg;

endmodule