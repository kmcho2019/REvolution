module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

wire [3:0] diff;
assign diff = A - B;

always @(*) begin
    if (diff[3] == 1'b1) begin // Negative result
        A_greater = 1'b0;
        A_equal = 1'b0;
        A_less = 1'b1;
    end else if (diff == 4'b0000) begin // Zero result
        A_greater = 1'b0;
        A_equal = 1'b1;
        A_less = 1'b0;
    end else begin // Positive result
        A_greater = 1'b1;
        A_equal = 1'b0;
        A_less = 1'b0;
    end
end

endmodule