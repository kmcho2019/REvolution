module div_16bit(
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

reg [15:0] a_reg;
reg [7:0]  b_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    reg [15:0] temp;
    reg [7:0]  div;
    reg [15:0] quot;
    reg [7:0]  rem;

    div = b_reg;
    quot = 0;
    rem = 0;
    temp = a_reg;

    for (int i = 15; i >= 0; i--) begin
        if (i < 8) begin
            rem = {rem[6:0], temp[15 - i]};
            if (rem >= div) begin
                rem = rem - div;
                quot[15 - i] = 1'b1;
            end
        end else begin
            if ({temp[15 - i : 8 - i], 8'b0} >= div) begin
                quot[15 - i] = 1'b1;
                temp[15 - i : 8 - i] = {temp[15 - i : 8 - i]} - div;
            end
        end
    end

    result = quot;
    odd = {8'b0, rem};
end

endmodule