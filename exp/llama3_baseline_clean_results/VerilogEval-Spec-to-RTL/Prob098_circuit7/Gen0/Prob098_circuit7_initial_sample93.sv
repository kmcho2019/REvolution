module TopModule(
    input clk,
    input a,
    output q
);

reg q_reg; // Register to hold the state of q
assign q = q_reg; // Continuous assignment to output q

always @(posedge clk) // Triggered at the positive edge of the clock
begin
    q_reg <= q_reg ^ a; // Update q_reg by XORing the current state with a
end

endmodule