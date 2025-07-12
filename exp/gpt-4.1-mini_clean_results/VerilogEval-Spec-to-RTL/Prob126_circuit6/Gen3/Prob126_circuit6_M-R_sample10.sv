module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    // Function that returns the LUT value based on input 'a'
    function [15:0] lut_func;
        input [2:0] addr;
        begin
            case (addr)
                3'd0: lut_func = 16'h1232;
                3'd1: lut_func = 16'haee0;
                3'd2: lut_func = 16'h27d4;
                3'd3: lut_func = 16'h5a0e;
                3'd4: lut_func = 16'h2066;
                3'd5: lut_func = 16'h64ce;
                3'd6: lut_func = 16'hc526;
                3'd7: lut_func = 16'h2f19;
                default: lut_func = 16'h0000;
            endcase
        end
    endfunction

    // Assign output by calling the function with input 'a'
    assign q = lut_func(a);

endmodule