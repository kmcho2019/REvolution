module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    typedef enum logic [1:0] {
        IDLE  = 2'd0,
        BYTE1 = 2'd1,
        BYTE2 = 2'd2,
        BYTE3 = 2'd3
    } state_t;

    state_t state, next_state;

    reg [7:0] byte1, byte2, byte3;

    // State transition logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (in[3] == 1'b1) // message start detected
                    next_state = BYTE1;
            end
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic for state, bytes, done, and out_bytes
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            byte3 <= 8'd0;
            done <= 1'b0;
            out_bytes <= 24'd0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default done low

            case (state)
                IDLE: begin
                    // no bytes captured, discard until in[3] = 1
                    // no output update
                end
                BYTE1: begin
                    byte1 <= in;
                end
                BYTE2: begin
                    byte2 <= in;
                end
                BYTE3: begin
                    byte3 <= in;
                    // On this cycle done is asserted and out_bytes updated
                    done <= 1'b1;
                    out_bytes <= {byte1, byte2, in};
                end
            endcase
        end
    end

endmodule