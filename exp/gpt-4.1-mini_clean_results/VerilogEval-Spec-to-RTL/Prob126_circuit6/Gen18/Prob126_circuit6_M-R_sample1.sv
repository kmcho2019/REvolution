module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    // Function implementing the LUT behavior
    function [15:0] decode;
        input [2:0] idx;
        begin
            case (idx)
                3'd0: decode = 16'h1232;
                3'd1: decode = 16'haee0;
                3'd2: decode = 16'h27d4;
                3'd3: decode = 16'h5a0e;
                3'd4: decode = 16'h2066;
                3'd5: decode = 16'h64ce;
                3'd6: decode = 16'hc526;
                3'd7: decode = 16'h2f19;
                default: decode = 16'h0000;
            endcase
        end
    endfunction

    // Continuous assignment using the function
    assign q = decode(a);

endmodule