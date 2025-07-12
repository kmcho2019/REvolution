module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE,
        BYTE2,
        BYTE3
    } state_t;

    reg [1:0] state, next_state;
    reg [23:0] msg_buffer;

    // FSM state transition
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            msg_buffer <= 24'b0;
            done <= 0;
        end else begin
            state <= next_state;
            
            // Shift in new byte when not in IDLE or when in[3]=1 in IDLE
            if ((state != IDLE) || (state == IDLE && in[3])) begin
                msg_buffer <= {msg_buffer[15:0], in};
            end
            
            // Assert done one cycle after third byte is received
            done <= (state == BYTE3);
        end
    end

    // FSM next state logic
    always_comb begin
        case (state)
            IDLE: next_state = in[3] ? BYTE2 : IDLE;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always_comb begin
        out_bytes = (done) ? msg_buffer : 24'bx;
    end

endmodule