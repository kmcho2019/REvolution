module ParamGate #(
    parameter FUNCTION = 0 // 0 = OR, 1 = NOR
) (
    input wire a,
    input wire b,
    output reg y
);
    // FUNCTION: 0 = OR, 1 = NOR
    always @(*) begin
        case (FUNCTION)
            0: y = a | b;
            1: y = ~(a | b);
            default: y = 1'bx;
        endcase
    end
endmodule

module TopModule (
    input wire in1,
    input wire in2,
    output wire out
);
    // Instantiate ParamGate with NOR function
    ParamGate #(.FUNCTION(1)) u_gate (
        .a(in1),
        .b(in2),
        .y(out)
    );
endmodule