module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    typedef enum reg [1:0] {
        IDLE  = 2'd0,
        BYTE1 = 2'd1,
        BYTE2 = 2'd2
    } state_t;

    state_t state, next_state;

    always @(*) begin
        done = 1'b0;
        case(state)
            IDLE: begin
                if (in[3])
                    next_state = BYTE1;
                else
                    next_state = IDLE;
            end
            BYTE1: begin
                next_state = BYTE2;
            end
            BYTE2: begin
                // After receiving third byte, signal done and return to IDLE
                done = 1'b1;
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done  <= 1'b0;  // although done is combinational, keep registered to avoid latch inference
        end else begin
            state <= next_state;
        end
    end

endmodule