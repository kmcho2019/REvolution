module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    // Use a combinational function to decode 'a' to 'q'
    function [15:0] decode;
        input [2:0] val;
        begin
            if (val == 3'd0)
                decode = 16'h1232;
            else if (val == 3'd1)
                decode = 16'haee0;
            else if (val == 3'd2)
                decode = 16'h27d4;
            else if (val == 3'd3)
                decode = 16'h5a0e;
            else if (val == 3'd4)
                decode = 16'h2066;
            else if (val == 3'd5)
                decode = 16'h64ce;
            else if (val == 3'd6)
                decode = 16'hc526;
            else if (val == 3'd7)
                decode = 16'h2f19;
            else
                decode = 16'h0000;
        end
    endfunction

    // Assign q by calling the combinational function
    assign q = decode(a);

endmodule