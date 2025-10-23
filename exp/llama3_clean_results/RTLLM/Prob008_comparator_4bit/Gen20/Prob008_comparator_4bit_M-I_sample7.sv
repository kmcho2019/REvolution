module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output reg        A_greater,
    output reg        A_equal,
    output reg        A_less
);

    // Simplified comparison logic using subtraction
    reg [4:0] diff;
    assign diff = {1'b0, A} - {1'b0, B};

    always @(*)
    begin
        if (diff == 0) begin
            A_greater = 0;
            A_equal = 1;
            A_less = 0;
        end else if (diff[4] == 0) begin // Positive result
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end else begin // Negative result
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end
    end

endmodule