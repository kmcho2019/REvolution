module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        BYTE1 = 2'b01,
        BYTE2 = 2'b10,
        BYTE3 = 2'b11
    } state_t;

    state_t state, next_state;

    reg [7:0] byte1, byte2, byte3;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte1 <= 8'h00;
            byte2 <= 8'h00;
            byte3 <= 8'h00;
            out_bytes <= 24'h0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default done to 0 each cycle

            case(state)
                IDLE: begin
                    if (in[3]) begin
                        byte1 <= in;
                    end
                end
                BYTE1: begin
                    byte2 <= in;
                end
                BYTE2: begin
                    byte3 <= in;
                end
                BYTE3: begin
                    // Nothing to latch here, output will be updated below
                end
            endcase

            // Output and done signal logic
            if (state == BYTE3) begin
                out_bytes <= {byte1, byte2, byte3};
                done <= 1'b1;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:  next_state = in[3] ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule