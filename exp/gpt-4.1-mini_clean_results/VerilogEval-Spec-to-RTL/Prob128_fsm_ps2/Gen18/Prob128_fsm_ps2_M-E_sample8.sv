module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        BYTE2 = 2'b01,
        BYTE3 = 2'b10
    } state_t;

    state_t state, next_state;

    wire start_byte = in[3];

    // Next state logic combinational block
    always @(*) begin
        done = 1'b0;
        case(state)
            IDLE: begin
                if (start_byte)
                    next_state = BYTE2;
                else
                    next_state = IDLE;
            end
            BYTE2: begin
                // On next byte regardless of in[3], move to BYTE3
                next_state = BYTE3;
            end
            BYTE3: begin
                // After third byte, signal done and go back to IDLE
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential state and done register update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done  <= 1'b0;
        end else begin
            state <= next_state;
            done  <= (state == BYTE3); // done asserted the cycle after third byte received
        end
    end

endmodule