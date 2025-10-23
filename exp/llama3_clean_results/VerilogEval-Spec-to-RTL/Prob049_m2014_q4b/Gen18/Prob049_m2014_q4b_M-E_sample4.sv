module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

reg d_reg; // Register to capture input data
reg q_reg; // Register for the output

always @(posedge clk) begin
    d_reg <= d; // Capture input data on every clock cycle
end

always @(posedge clk or posedge ar) begin
    if (ar) begin
        q_reg <= 1'b0; // Reset output register on asynchronous reset
    end else begin
        q_reg <= d_reg; // Update output register with captured data
    end
end

assign q = q_reg; // Assign output of Q_Reg to the output port

endmodule