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
            remainder = A[15:8];
            if (remainder >= B) begin
                quotient[7] = 1;
                remainder = remainder - B;
            end
            state = 4'd1;
        end
        4'd1: begin
            if (remainder >= {8'd0, B[7:4]}) begin
                quotient[6:4] = quotient[6:4] | (1 << 1);
                remainder = remainder - {8'd0, B[7:4]};
            end
            remainder = {remainder, A[7:4]};
            state = 4'd2;
        end
        4'd2: begin
            if (remainder >= {8'd0, B[7:0]}) begin
                quotient[3:0] = quotient[3:0] | (1 << 2);
                remainder = remainder - {8'd0, B[7:0]};
            end
            remainder = {remainder, A[3:0]};
            state = 4'd3;
        end
        4'd3: begin
            result = quotient;
            odd = remainder;
            state = 4'd0;
        end
        default: state = 4'd0;
    endcase
end

assign result = quotient;
assign odd = remainder;

endmodule