module TopModule(
    input clk,
    input x,
    output z
);

// Stage 1: Calculate the second inputs of the XOR, AND, and OR gates
wire xor_in, and_in, or_in;
reg q1, q2, q3;
reg stage1_q1, stage1_q2, stage1_q3;

assign xor_in = q1;
assign and_in = ~q2;
assign or_in = ~q3;

// Stage 2: Calculate the outputs of the XOR, AND, and OR gates
wire xor_out, and_out, or_out;

assign xor_out = x ^ xor_in;
assign and_out = x & and_in;
assign or_out = x | or_in;

// Stage 3: Store the outputs of the XOR, AND, and OR gates in registers
always @(posedge clk) begin
    stage1_q1 <= xor_out;
    stage1_q2 <= and_out;
    stage1_q3 <= or_out;
    q1 <= stage1_q1;
    q2 <= stage1_q2;
    q3 <= stage1_q3;
end

// Stage 4: Calculate the output 'z'
assign z = ~(q1 | q2 | q3);

// Initialize the registers
initial begin
    q1 = 1'b0;
    q2 = 1'b0;
    q3 = 1'b0;
    stage1_q1 = 1'b0;
    stage1_q2 = 1'b0;
    stage1_q3 = 1'b0;
end

endmodule