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
            for (int i = 15; i >= 0; i--) begin
                remainder = {remainder[7:0], A[i]};
                if (remainder >= {8'd0, B}) begin
                    quotient = quotient | (1 << i);
                    remainder = remainder - {8'd0, B};
                end
            end
            state = 4'd2;
        end
        4'd2: begin
            result = quotient;
            odd = {8'd0, remainder[7:0]};
        end
        default: begin
            state = 4'd0;
        end
    endcase
end

assign result = quotient;
assign odd = {8'd0, remainder[7:0]};

endmodule