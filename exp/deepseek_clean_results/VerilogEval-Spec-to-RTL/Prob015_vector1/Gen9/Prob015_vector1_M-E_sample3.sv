module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Function to split a word into upper and lower halves
    function [15:0] split_word;
        input [15:0] data;
        parameter SPLIT = 8;
        begin
            split_word = {data[SPLIT +: SPLIT], data[0 +: SPLIT]};
        end
    endfunction

    // Use the function to assign outputs
    assign {out_hi, out_lo} = split_word(in, 8);

endmodule