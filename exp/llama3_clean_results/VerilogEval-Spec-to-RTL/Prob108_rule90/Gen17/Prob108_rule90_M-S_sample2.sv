module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

genvar i;
generate
    for (i = 0; i < 512; i++) begin
        // Calculate next state directly with boundary conditions handled inline
        assign q[i] = (i == 0) ? q_reg[0] ^ (i == 511 ? 1'b0 : q_reg[i + 1]) : 
                       (i == 511) ? q_reg[i - 1] ^ 1'b0 : q_reg[i - 1] ^ q_reg[i + 1];
    end
endgenerate

// Sequential logic to update q_reg on the positive edge of the clock
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        // Update q_reg directly for simplicity and efficiency
        q_reg <= q;
    end
end

endmodule