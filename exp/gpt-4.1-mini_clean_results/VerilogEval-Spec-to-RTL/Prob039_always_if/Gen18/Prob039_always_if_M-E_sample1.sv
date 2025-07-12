module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);

    wire sel_final;
    wire [1:0] sel_encoded;

    // Combine selects with AND for mux control
    assign sel_final = sel_b1 & sel_b2;

    // Continuous assignment without ?: operator
    // out_assign = (sel_final & b) | (~sel_final & a);
    assign out_assign = (sel_final & b) | (~sel_final & a);

    // Encode combined select bits into a 2-bit vector
    assign sel_encoded = {sel_b1, sel_b2};

    // Procedural mux using case statement on encoded selects
    always @(*) begin
        case(sel_encoded)
            2'b11: out_always = b; // both selects true, choose b
            default: out_always = a; // otherwise choose a
        endcase
    end

endmodule