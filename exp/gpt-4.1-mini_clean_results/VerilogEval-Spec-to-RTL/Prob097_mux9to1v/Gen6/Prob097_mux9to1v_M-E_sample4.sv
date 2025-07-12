module TopModule(
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0]  sel,
    output [15:0] out
);

    // Concatenate all inputs into a single 144-bit bus (9*16)
    wire [143:0] inputs_concat = {a, b, c, d, e, f, g, h, i};

    // Function to extract 16-bit chunk from concatenated inputs based on sel
    function [15:0] select_input;
        input [3:0] index;
        begin
            // Because inputs_concat is {a,b,c,...,i} with a as MSB,
            // index 0 means bits [143:128] for 'a', index 1 means [127:112] for 'b', etc.
            if (index <= 4'd8) begin
                select_input = inputs_concat[143 - 16*index -: 16];
            end else begin
                select_input = 16'hFFFF;
            end
        end
    endfunction

    assign out = select_input(sel);

endmodule