module TopModule(
    input clk,
    input rst_n, // added reset signal
    input x,
    output z
);

reg q1, q2, q3;

// XOR gate
wire xor_out;
assign xor_out = x ^ q1;

// AND gate
wire and_out;
assign and_out = x & ~q2;

// OR gate
wire or_out;
assign or_out = x | ~q3;

// D flip-flops
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // active low reset
        q1 <= 1'b0;
        q2 <= 1'b0;
        q3 <= 1'b0;
    end else begin
        q1 <= xor_out;
        q2 <= and_out;
        q3 <= or_out;
    end
end

// NOR gate
assign z = ~(q1 | q2 | q3);

endmodule