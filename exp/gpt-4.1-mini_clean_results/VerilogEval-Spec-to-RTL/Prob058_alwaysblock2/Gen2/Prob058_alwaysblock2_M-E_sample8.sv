module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Central wire for XOR of a and b
    wire xor_comb = a ^ b;

    // Assign output directly from the wire
    assign out_assign = xor_comb;

    // Combinational always block drives output from the wire
    always @(*) begin
        out_always_comb = xor_comb;
    end

    // Sequential always block registers the XOR value on clock edge
    always @(posedge clk) begin
        out_always_ff <= xor_comb;
    end

endmodule