module TopModule (
    input  clk,
    input  reset,
    output reg shift_ena
);

    typedef enum logic [0:0] {
        INIT = 1'b0,
        IDLE = 1'b1
    } state_t;

    state_t state, next_state;
    reg [2:0] count; // 3 bits enough to count to 4

    always @(posedge clk) begin
        if (reset) begin
            state <= INIT;
            count <= 3'd4;
        end else begin
            state <= next_state;
            if (state == INIT && count != 0)
                count <= count - 1;
            else
                count <= count;
        end
    end

    always @(*) begin
        case (state)
            INIT: begin
                if (count == 1)
                    next_state = IDLE;
                else
                    next_state = INIT;
            end
            IDLE: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    always @(*) begin
        shift_ena = (state == INIT && count != 0);
    end

endmodule