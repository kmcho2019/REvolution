module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE  = 2'b00,
        BYTE2 = 2'b01,
        BYTE3 = 2'b10
    } state_t;

    reg [1:0] state, next_state;

    // Next-state logic
    always @(*) begin
        done = 1'b0; // default
        case(state)
            IDLE: begin
                if (in[3])
                    next_state = BYTE2;
                else
                    next_state = IDLE;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                done = 1'b1;  // Assert done after third byte
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // State register and synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            state <= next_state;
            // done updated combinationally, keep registered done from combinational always block
            if (state == BYTE3)
                done <= 1'b1;
            else
                done <= 1'b0;
        end
    end

endmodule