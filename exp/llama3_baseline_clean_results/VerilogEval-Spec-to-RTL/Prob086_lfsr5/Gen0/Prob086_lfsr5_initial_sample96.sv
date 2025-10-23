module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] q_reg;

initial begin
    q_reg = 5'b10000; // initialize the LFSR to any non-zero value
end

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 5'b10000; // reset the LFSR output to 1
    end else begin
        q_reg[4] <= q_reg[3] ^ q_reg[0]; // tap at position 5
        q_reg[3] <= q_reg[2] ^ q_reg[0]; // tap at position 3
        q_reg[2] <= q_reg[1];
        q_reg[1] <= q_reg[0];
        q_reg[0] <= 0; // shift in a zero
    end
end

assign q = q_reg;

endmodule