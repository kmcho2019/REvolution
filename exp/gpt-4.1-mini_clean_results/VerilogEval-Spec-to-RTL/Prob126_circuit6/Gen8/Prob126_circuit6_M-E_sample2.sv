module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    // Function returns the constant 16-bit value corresponding to input a
    function [15:0] lookup_value;
        input [2:0] idx;
        begin
            case (idx)
                3'd0: lookup_value = 16'h1232;
                3'd1: lookup_value = 16'haee0;
                3'd2: lookup_value = 16'h27d4;
                3'd3: lookup_value = 16'h5a0e;
                3'd4: lookup_value = 16'h2066;
                3'd5: lookup_value = 16'h64ce;
                3'd6: lookup_value = 16'hc526;
                3'd7: lookup_value = 16'h2f19;
                default: lookup_value = 16'h0000; // Default case
            endcase
        end
    endfunction

    // Assign output combinationally via the function
    assign q = lookup_value(a);

endmodule