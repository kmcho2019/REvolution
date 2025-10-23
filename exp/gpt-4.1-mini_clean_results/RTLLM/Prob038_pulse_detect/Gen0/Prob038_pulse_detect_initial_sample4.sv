module pulse_detect (
    input wire clk,
    input wire rst_n,
    input wire data_in,
    output reg data_out
);

    typedef enum reg [1:0] {
        IDLE = 2'd0,
        WAIT_1 = 2'd1,
        WAIT_0 = 2'd2
    } state_t;

    state_t state, next_state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            if (state == WAIT_0 && data_in == 1'b0)
                data_out <= 1'b1;  // pulse detected at this cycle
            else
                data_out <= 1'b0;
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in == 1'b0)
                    next_state = WAIT_1; // wait for rising edge
                else
                    next_state = IDLE;
            end
            WAIT_1: begin
                if (data_in == 1'b1)
                    next_state = WAIT_0; // rising edge detected, wait for falling edge
                else if (data_in == 1'b0)
                    next_state = WAIT_1; // keep waiting for rising edge
                else
                    next_state = IDLE; // default back
            end
            WAIT_0: begin
                if (data_in == 1'b0)
                    next_state = WAIT_1; // pulse ended, start again
                else if (data_in == 1'b1)
                    next_state = WAIT_0; // remain until falling edge
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule