module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    // Combinational function implementing the lookup using a case statement
    function [15:0] lookup;
        input [2:0] addr;
        begin
            case(addr)
                3'd0: lookup = 16'h1232;
                3'd1: lookup = 16'haee0;
                3'd2: lookup = 16'h27d4;
                3'd3: lookup = 16'h5a0e;
                3'd4: lookup = 16'h2066;
                3'd5: lookup = 16'h64ce;
                3'd6: lookup = 16'hc526;
                3'd7: lookup = 16'h2f19;
                default: lookup = 16'h0000;
            endcase
        end
    endfunction

    // Continuous assignment from the function output
    assign q = lookup(a);

endmodule