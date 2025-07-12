module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    typedef enum reg [1:0] {
        IDLE  = 2'b00, // waiting for start byte (in[3] == 1)
        BYTE2 = 2'b01, // second byte of message
        BYTE3 = 2'b10  // third byte of message
    } state_t;

    state_t state, next_state;
    wire start_byte = in[3];

    // Next state logic
    always @(*) begin
        done = 1'b0;
        case (state)
            IDLE: begin
                if (start_byte)
                    next_state = BYTE2;
                else
                    next_state = IDLE;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                done = 1'b1;    // assert done for one cycle after 3rd byte
                if (start_byte)
                    next_state = BYTE2; // immediately start next message if new start byte
                else
                    next_state = IDLE;  // otherwise back to IDLE
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // State update on clock
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            state <= next_state;
        end
    end

endmodule