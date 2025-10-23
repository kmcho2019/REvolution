module PriorityEncoder(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [1:0] priority
);

assign priority = (a < b && a < c && a < d) ? 2'b11 :
                 (b < a && b < c && b < d) ? 2'b10 :
                 (c < a && c < b && c < d) ? 2'b01 :
                 2'b00;

endmodule

module Selector(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    input [1:0] priority,
    output [7:0] min
);

assign min = (priority == 2'b11) ? a :
             (priority == 2'b10) ? b :
             (priority == 2'b01) ? c :
             d;

endmodule

module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

wire [1:0] priority;

PriorityEncoder encoder(
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .priority(priority)
);

Selector selector(
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .priority(priority),
    .min(min)
);

endmodule