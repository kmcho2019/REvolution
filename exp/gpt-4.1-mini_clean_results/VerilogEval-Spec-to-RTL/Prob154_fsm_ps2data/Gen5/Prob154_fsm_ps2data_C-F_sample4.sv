module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg        done
);

    // FSM state encoding (2-bit binary)
    localparam IDLE  = 2'd0;
    localparam BYTE2 = 2'd1;
    localparam BYTE3 = 2'd2;

    reg [1:0] state, next_state;

    reg [7:0] byte1_reg, byte2_reg;

    // Sequential logic: FSM state, byte registers, done and out_bytes
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            byte1_reg <= 8'd0;
            byte2_reg <= 8'd0;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Default done low every cycle, asserted only on BYTE3
            done <= 1'b0;

            case(state)
                IDLE: begin
                    // Latch byte1 only when in[3] == 1 indicating message start
                    if (in[3]) begin
                        byte1_reg <= in;
                    end
                end
                BYTE2: begin
                    // Latch second byte only in BYTE2 state
                    byte2_reg <= in;
                end
                BYTE3: begin
                    // Assert done in the same cycle as third byte received
                    done <= 1'b1;
                    // Compose out_bytes combinationally from registered byte1, byte2, and input in third byte
                    out_bytes <= {byte1_reg, byte2_reg, in};
                end
                default: ;
            endcase
        end
    end

    // Combinational next state logic with conditional input check only in IDLE
    always @(*) begin
        case(state)
            IDLE:  next_state = (in[3]) ? BYTE2 : IDLE;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule