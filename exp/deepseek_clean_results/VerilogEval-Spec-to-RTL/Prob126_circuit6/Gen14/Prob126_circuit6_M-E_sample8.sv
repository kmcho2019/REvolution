module TopModule (
    input [2:0] a,
    output [15:0] q
);

// Nibble generation functions
function [3:0] nibble0;
    input [2:0] a;
    begin
        nibble0 = {a[1:0], a[2]} ^ 3'h3; // Rotate left 1 and XOR
    end
endfunction

function [3:0] nibble1;
    input [2:0] a;
    begin
        nibble1 = (a + 3'h5) ^ 4'hA;
    end
endfunction

function [3:0] nibble2;
    input [2:0] a;
    begin
        nibble2 = (a * 3'h3) ^ 4'h5;
    end
endfunction

function [3:0] nibble3;
    input [2:0] a;
    begin
        nibble3 = {a[0], a[2:1]} + 3'h7; // Rotate right 1 and add
    end
endfunction

// Combine nibbles to form output
assign q = {nibble3(a), nibble2(a), nibble1(a), nibble0(a)};

endmodule