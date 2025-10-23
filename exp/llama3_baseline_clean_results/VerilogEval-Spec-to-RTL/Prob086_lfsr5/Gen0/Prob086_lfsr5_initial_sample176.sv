module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] q_reg; // Register to store the current state of the LFSR

// Combinational logic to calculate the next state
always @(*) begin
    if (reset) begin
        q_reg = 5'b1; // Reset the LFSR output to 1
    end else begin
        q_reg = {q[4:1], q[4] ^ q[2]}; // Calculate the next state
    end
end

// Assign the next state to the register on the positive edge of the clock
always @(posedge clk) begin
    q <= q_reg;
end

endmodule