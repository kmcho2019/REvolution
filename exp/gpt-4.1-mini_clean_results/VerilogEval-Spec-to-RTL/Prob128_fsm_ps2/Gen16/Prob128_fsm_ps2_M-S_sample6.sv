module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    typedef enum reg [1:0] {
        IDLE = 2'd0,
        BYTE2 = 2'd1,
        BYTE3 = 2'd2
    } state_t;

    reg [1:0] state, next_state;

    always @(*) begin
        done = 1'b0;
        case(state)
            IDLE: 
                if (in[3]) 
                    next_state = BYTE2;
                else 
                    next_state = IDLE;
            BYTE2:
                next_state = BYTE3;
            BYTE3: begin
                next_state = IDLE;
                done = 1'b1;
            end
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

endmodule