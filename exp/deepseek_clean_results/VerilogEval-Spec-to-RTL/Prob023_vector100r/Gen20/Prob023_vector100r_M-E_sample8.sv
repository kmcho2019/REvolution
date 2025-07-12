module TopModule (
    input  [99:0] in,
    output [99:0] out
);

// Base case module for 2-bit reversal
module Reverse2 (
    input  [1:0] in,
    output [1:0] out
);
    assign out = {in[0], in[1]};
endmodule

// Parameterized recursive reversal module
module ReverseN #(parameter WIDTH = 100) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);
    generate
        if (WIDTH == 2) begin : base_case
            Reverse2 rev2(.in(in), .out(out));
        end
        else begin : recursive_case
            localparam HALF_WIDTH = WIDTH / 2;
            wire [HALF_WIDTH-1:0] first_half_rev;
            wire [HALF_WIDTH-1:0] second_half_rev;
            
            ReverseN #(HALF_WIDTH) rev_first(.in(in[HALF_WIDTH-1:0]), .out(first_half_rev));
            ReverseN #(HALF_WIDTH) rev_second(.in(in[WIDTH-1:HALF_WIDTH]), .out(second_half_rev));
            
            assign out = {second_half_rev, first_half_rev};
        end
    endgenerate
endmodule

// Handle non-power-of-two case by padding to 128 bits
wire [127:0] padded_in = {{28{1'b0}}, in};
wire [127:0] padded_out;

ReverseN #(128) rev128(.in(padded_in), .out(padded_out));

assign out = padded_out[99:0];

endmodule