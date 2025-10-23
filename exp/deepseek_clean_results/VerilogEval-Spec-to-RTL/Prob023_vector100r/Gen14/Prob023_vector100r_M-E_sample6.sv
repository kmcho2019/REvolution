module TopModule (
    input  [99:0] in,
    output [99:0] out
);

// Function to reverse bits of any width
function automatic [99:0] reverse_bits;
    input [99:0] data;
    integer i;
    begin
        for (i = 0; i < 100; i = i + 1) begin
            reverse_bits[i] = data[99-i];
        end
    end
endfunction

// Continuous assignment using the function
assign out = reverse_bits(in);

endmodule