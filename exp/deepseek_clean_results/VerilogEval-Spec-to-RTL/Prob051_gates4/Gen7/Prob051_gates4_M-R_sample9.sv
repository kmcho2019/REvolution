module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // AND gate - using reduction operator for compactness
    assign out_and = &in;

    // OR gate - implemented with always block and case statement
    reg or_result;
    always @(*) begin
        case (in)
            4'b0000: or_result = 1'b0;
            default: or_result = 1'b1;
        endcase
    end
    assign out_or = or_result;

    // XOR gate - explicit tree structure with named intermediate values
    wire pair1_xor = in[0] ^ in[1];
    wire pair2_xor = in[2] ^ in[3];
    assign out_xor = pair1_xor ^ pair2_xor;

endmodule