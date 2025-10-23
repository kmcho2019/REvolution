module XORGate (
    input a,
    input b,
    output y
);
    assign y = a ^ b;
endmodule

module DFlipFlop (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input clk,
    input in,
    output out
);
    wire xor_out;
    wire q;

    XORGate xor_inst (
        .a(in),
        .b(q),
        .y(xor_out)
    );

    DFlipFlop dff_inst (
        .clk(clk),
        .d(xor_out),
        .q(q)
    );

    assign out = q;

endmodule