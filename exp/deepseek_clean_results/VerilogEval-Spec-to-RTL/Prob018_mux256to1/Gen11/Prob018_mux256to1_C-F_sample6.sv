module Mux256to1 #(
    parameter WIDTH = 256
) (
    input  [WIDTH-1:0] in,
    input  [$clog2(WIDTH)-1:0] sel,
    output out
);

    // Parameter validation
    initial begin
        if (WIDTH != 256) begin
            $display("Warning: This module is optimized for 256 inputs but got %0d", WIDTH);
        end
    end

    // Direct bit selection - most efficient implementation
    assign out = in[sel];

endmodule