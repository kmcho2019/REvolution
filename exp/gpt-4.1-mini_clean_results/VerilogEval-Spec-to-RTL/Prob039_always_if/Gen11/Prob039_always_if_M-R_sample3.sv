module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);

    // Combine select signals
    wire sel_final = sel_b1 & sel_b2;

    // Continuous assign for out_assign using ternary operator directly
    assign out_assign = sel_final ? b : a;

    // Procedural block using case statement for out_always
    always @(*) begin
        case (sel_final)
            1'b1: out_always = b;
            default: out_always = a;
        endcase
    end

endmodule