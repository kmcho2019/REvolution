module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);

    wire sel;

    // Combine select signals into an intermediate wire to reduce redundant logic
    assign sel = sel_b1 & sel_b2;

    // Continuous assignment using ternary operator for clear mux logic
    assign out_assign = sel ? b : a;

    // Procedural block using a case statement on sel for clarity and consistency
    always @(*) begin
        case (sel)
            1'b1: out_always = b;
            default: out_always = a;
        endcase
    end

endmodule