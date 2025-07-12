module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);
    // Internal function to split 16-bit input into high and low 8-bit parts
    function [15:0] split16;
        input [15:0] data_in;
        begin
            split16 = data_in;
        end
    endfunction

    // Assign outputs by slicing the function's return value
    // Using the function is mainly for code clarity and encapsulation
    wire [15:0] split_result = split16(in);
    assign out_hi = split_result[15:8];
    assign out_lo = split_result[7:0];

endmodule