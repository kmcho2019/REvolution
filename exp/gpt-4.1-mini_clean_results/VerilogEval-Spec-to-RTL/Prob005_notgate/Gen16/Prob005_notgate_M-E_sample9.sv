module Inverter (
    input wire a,
    output wire y
);
    assign y = ~a;
endmodule

module TopModule (
    input wire in,
    output wire out
);
    Inverter inv_inst (
        .a(in),
        .y(out)
    );
endmodule