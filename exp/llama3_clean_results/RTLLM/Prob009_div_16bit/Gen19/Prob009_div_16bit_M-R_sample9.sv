module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] quotient;
reg [15:0] remainder;
reg [3:0] state;

always @(*) begin
    case (state)
        4'd0: begin
            quotient = 0;
            remainder = 0;
            state = 4'd1;
        end
        4'd1: begin
            remainder = {remainder[7:0], A[15]};
            if (remainder >= {8'd0, B}) begin
                quotient = quotient | (1 << 15);
                remainder = remainder - {8'd0, B};
            end
            state = 4'd2;
        end
        4'd2: begin
            remainder = {remainder[7:0], A[14]};
            if (remainder >= {8'd0, B}) begin
                quotient = quotient | (1 << 14);
                remainder = remainder - {8'd0, B};
            end
            state = 4'd3;
        end
        4'd3: begin
            remainder = {remainder[7:0], A[13]};
            if (remainder >= {8'd0, B}) begin
                quotient = quotient | (1 << 13);
                remainder = remainder - {8'd0, B};
            end
            state = 4'd4;
        end
        4'd4: begin
            remainder = {remainder[7:0], A[12]};
            if (remainder >= {8'd0, B}) begin
                quotient = quotient | (1 << 12);
                remainder = remainder - {8'd0, B};
            end
            state = 4'd5;
        end
        4'd5: begin
            remainder = {remainder[7:0], A[11]};
            if (remainder >= {8'd0, B}) begin
                quotient = quotient | (1 << 11);
                remainder = remainder - {8'd0, B};
            end
            state = 4'd6;
        end
        4'd6: begin
            remainder = {remainder[7:0], A[10]};
            if (remainder >= {8'd0, B}) begin
                quotient = quotient | (1 << 10);
                remainder = remainder - {8'd0, B};
            end
            state = 4'd7;
        end
        4'd7: begin
            remainder = {remainder[7:0], A[9]};
            if (remainder >= {8'd0, B}) begin
                quotient = quotient | (1 << 9);
                remainder = remainder - {8'd0, B};
            end
            state = 4'd8;
        end
        4'd8: begin
            remainder = {remainder[7:0], A[8]};
            if (remainder >= {8'd0, B}) begin
                quotient = quotient | (1 << 8);
                remainder = remainder - {8'd0, B};
            end
            state = 4'd9;
        end
        4'd9: begin
            remainder = {remainder[7:0], A[7]};
            if (remainder >= {8'd0, B}) begin
                quotient = quotient | (1 << 7);
                remainder = remainder - {8'd0, B};
            end
            state = 4'd10;
        end
        4'd10: begin
            remainder = {remainder[7:0], A[6]};
            if (remainder >= {8'd0, B}) begin
                quotient = quotient | (1 << 6);
                remainder = remainder - {8'd0, B};
            end
            state = 4'd11;
        end
        4'd11: begin
            remainder = {remainder[7:0], A[5]};
            if (remainder >= {8'd0, B}) begin
                quotient = quotient | (1 << 5);
                remainder = remainder - {8'd0, B};
            end
            state = 4'd12;
        end
        4'd12: begin
            remainder = {remainder[7:0], A[4]};
            if (remainder >= {8'd0, B}) begin
                quotient = quotient | (1 << 4);
                remainder = remainder - {8'd0, B};
            end
            state = 4'd13;
        end
        4'd13: begin
            remainder = {remainder[7:0], A[3]};
            if (remainder >= {8'd0, B}) begin
                quotient = quotient | (1 << 3);
                remainder = remainder - {8'd0, B};
            end
            state = 4'd14;
        end
        4'd14: begin
            remainder = {remainder[7:0], A[2]};
            if (remainder >= {8'd0, B}) begin
                quotient = quotient | (1 << 2);
                remainder = remainder - {8'd0, B};
            end
            state = 4'd15;
        end
        4'd15: begin
            remainder = {remainder[7:0], A[1]};
            if (remainder >= {8'd0, B}) begin
                quotient = quotient | (1 << 1);
                remainder = remainder - {8'd0, B};
            end
            state = 4'd16;
        end
        default: begin
            remainder = {remainder[7:0], A[0]};
            if (remainder >= {8'd0, B}) begin
                quotient = quotient | (1 << 0);
                remainder = remainder - {8'd0, B};
            end
            result = quotient;
            odd = {8'd0, remainder[7:0]};
        end
    endcase
end

endmodule