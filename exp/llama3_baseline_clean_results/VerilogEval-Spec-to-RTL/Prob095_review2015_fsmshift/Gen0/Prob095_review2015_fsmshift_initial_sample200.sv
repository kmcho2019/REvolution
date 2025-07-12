module TopModule(
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] state; // 0: IDLE, 1: SHIFT, 2: SHIFT_COUNT_1, 3: SHIFT_COUNT_2, 
                 // but we will use enum to make it more readable
enum {IDLE, SHIFT, SHIFT_COUNT_1, SHIFT_COUNT_2, SHIFT_COUNT_3} curr_state, next_state;

always @(posedge clk) begin
    if(reset) begin
        curr_state <= IDLE;
        shift_ena <= 1'b1;
    end else begin
        curr_state <= next_state;
    end
end

always @(*) begin
    case(curr_state)
        IDLE: begin
            if(reset) begin
                next_state = SHIFT;
            end else begin
                next_state = IDLE;
                shift_ena = 1'b0;
            end
        end
        SHIFT: begin
            next_state = SHIFT_COUNT_1;
            shift_ena = 1'b1;
        end
        SHIFT_COUNT_1: begin
            next_state = SHIFT_COUNT_2;
            shift_ena = 1'b1;
        end
        SHIFT_COUNT_2: begin
            next_state = SHIFT_COUNT_3;
            shift_ena = 1'b1;
        end
        SHIFT_COUNT_3: begin
            next_state = IDLE;
            shift_ena = 1'b0;
        end
        default: begin
            next_state = IDLE;
            shift_ena = 1'b0;
        end
    endcase
end

endmodule