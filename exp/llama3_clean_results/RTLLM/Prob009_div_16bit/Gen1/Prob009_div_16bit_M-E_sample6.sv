module div_16bit(
    input clk,
    input reset,
    input  [15:0] A,
    input  [7:0]  B,
    output [15:0] result,
    output [15:0] odd
);

reg [15:0] dividend;
reg [7:0]  divisor;
reg [15:0] quotient;
reg [15:0] remainder;
reg [3:0]  shift_count;

enum logic [1:0] {IDLE, SHIFT, SUBTRACT} state, next_state;

always @(*) begin
    case(state)
        IDLE: begin
            if (A!= 0 && B!= 0) begin
                next_state = SHIFT;
            end else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            if (shift_count == 8) begin
                next_state = SUBTRACT;
            end else if (divisor << shift_count >= dividend[15:8]) begin
                next_state = SUBTRACT;
            end else begin
                next_state = SHIFT;
            end
        end
        SUBTRACT: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        dividend <= 0;
        divisor <= 0;
        quotient <= 0;
        remainder <= 0;
        shift_count <= 0;
    end else begin
        case(state)
            IDLE: begin
                dividend <= A;
                divisor <= B;
                quotient <= 0;
                remainder <= 0;
                shift_count <= 0;
                state <= next_state;
            end
            SHIFT: begin
                if (divisor << shift_count < dividend[15:8]) begin
                    shift_count <= shift_count + 1;
                end
                state <= next_state;
            end
            SUBTRACT: begin
                quotient[15-shift_count] <= 1;
                remainder <= (dividend[15:8] - (divisor << shift_count)) << 8 | dividend[7:0];
                dividend <= remainder;
                shift_count <= 0;
                state <= next_state;
            end
            default: state <= next_state;
        endcase
    end
end

always @(*) begin
    result = quotient;
    odd = remainder;
end

endmodule