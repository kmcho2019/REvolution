module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output reg   A_greater,
    output reg   A_equal,
    output reg   A_less
);

    wire [3:0] diff;
    assign diff = {1'b0, A} - {1'b0, B};

    always @(*) begin
        if (diff == 0)
        begin
            A_equal   = 1'b1;
            A_greater = 1'b0;
            A_less    = 1'b0;
        end
        else if (diff[3] == 0) // MSB is sign bit: 0 means diff positive
        begin
            A_equal   = 1'b0;
            A_greater = 1'b1;
            A_less    = 1'b0;
        end
        else
        begin
            A_equal   = 1'b0;
            A_greater = 1'b0;
            A_less    = 1'b1;
        end
    end

endmodule