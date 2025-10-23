module TopModule (
    input  [2:0] a,
    output [15:0] q
);

function [15:0] lut;
    input [2:0] idx;
    begin
        case (idx)
            3'd0: lut = 16'h1232;
            3'd1: lut = 16'haee0;
            3'd2: lut = 16'h27d4;
            3'd3: lut = 16'h5a0e;
            3'd4: lut = 16'h2066;
            3'd5: lut = 16'h64ce;
            3'd6: lut = 16'hc526;
            3'd7: lut = 16'h2f19;
            default: lut = 16'h0000;
        endcase
    end
endfunction

assign q = lut(a);

endmodule