module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

enum logic [1:0] {IDLE, DIVIDE, DONE} state, next_state;
reg [15:0] dividend;
reg [7:0] divisor;
reg [15:0] quotient;
reg [15:0] remainder;
reg [3:0] counter;

always @(*) begin
    case(state)
        IDLE: next_state = (A != 0 || B != 0) ? DIVIDE : IDLE;
        DIVIDE: next_state = (counter < 16) ? DIVIDE : DONE;
        DONE: next_state = IDLE;
    endcase
end

always @(posedge state) begin
    case(state)
        IDLE: begin
            dividend = A;
            divisor = B;
            quotient = 0;
            remainder = 0;
            counter = 0;
        end
        DIVIDE: begin
            remainder = {remainder[7:0], dividend[15-counter]};
            if (remainder >= {8'd0, divisor}) begin
                quotient = quotient | (1 << (15-counter));
                remainder = remainder - {8'd0, divisor};
            end
            counter = counter + 1;
        end
        DONE: begin
            result = quotient;
            odd = {8'd0, remainder[7:0]};
        end
    endcase
end

endmodule