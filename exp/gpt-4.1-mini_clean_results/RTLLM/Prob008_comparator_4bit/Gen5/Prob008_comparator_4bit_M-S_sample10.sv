module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [4:0] diff;

    // Perform subtraction with an extra bit to detect borrow (underflow)
    assign diff = {1'b0, A} - {1'b0, B};

    assign A_less    = diff[4];           // MSB=1 means borrow occurred => A < B
    assign A_equal   = (diff[3:0] == 4'b0000) && !diff[4];
    assign A_greater = !diff[4] && (diff[3:0] != 4'b0000);

endmodule