module TopModule(
    input [2:0] a,
    output [15:0] q
);

// Function to generate the lookup table
function [15:0] lut;
    input [2:0] index;
    begin
        case (index)
            3'b000: lut = 16'h1232;
            3'b001: lut = 16'haee0;
            3'b010: lut = 16'h27d4;
            3'b011: lut = 16'h5a0e;
            3'b100: lut = 16'h2066;
            3'b101: lut = 16'h64ce;
            3'b110: lut = 16'hc526;
            3'b111: lut = 16'h2f19;
            default: lut = 16'hxxxx;
        endcase
    end
endfunction

// Assign output based on the lookup table
assign q = lut(a);

endmodule