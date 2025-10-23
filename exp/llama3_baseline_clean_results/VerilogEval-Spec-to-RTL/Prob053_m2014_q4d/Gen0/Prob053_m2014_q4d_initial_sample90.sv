module TopModule(clk, in, out);
    input clk;
    input in;
    output out;
    reg out; // out is also used as an input to the XOR, hence reg

    wire xor_out;

    // The XOR gate
    assign xor_out = in ^ out;

    // The D flip-flop
    always @(posedge clk) begin
        out <= xor_out;
    end
endmodule