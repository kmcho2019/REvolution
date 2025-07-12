module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    // Base case for 2-bit reversal
    module Reverse2 #(
        parameter WIDTH = 2
    ) (
        input  [WIDTH-1:0] in,
        output [WIDTH-1:0] out
    );
        assign out = {in[0], in[1]};
    endmodule

    // Recursive case for larger vectors
    generate
        if (WIDTH <= 2) begin
            Reverse2 r2 (.in(in), .out(out));
        end
        else begin
            localparam HALF = WIDTH / 2;
            wire [HALF-1:0] first_half_rev;
            wire [WIDTH-HALF-1:0] second_half_rev;
            
            // Reverse each half recursively
            TopModule #(HALF) rev_first (
                .in(in[HALF-1:0]),
                .out(first_half_rev)
            );
            
            TopModule #(WIDTH-HALF) rev_second (
                .in(in[WIDTH-1:HALF]),
                .out(second_half_rev)
            );
            
            // Combine reversed halves in reverse order
            assign out = {second_half_rev, first_half_rev};
        end
    endgenerate

endmodule