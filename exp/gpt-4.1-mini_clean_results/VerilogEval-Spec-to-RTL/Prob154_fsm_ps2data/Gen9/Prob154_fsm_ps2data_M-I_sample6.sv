module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // States for the FSM
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        BYTE2 = 2'b01,
        BYTE3 = 2'b10
    } state_t;
    state_t state, next_state;

    reg [23:0] shift_reg;
    reg [7:0] in_reg;

    // Register input to reduce combinational path
    always @(posedge clk) begin
        if (reset)
            in_reg <= 8'd0;
        else
            in_reg <= in;
    end

    // FSM sequential logic with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 24'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default no done

            case (state)
                IDLE: begin
                    if (in_reg[3]) begin
                        // Load first byte only if start detected
                        shift_reg <= {16'd0, in_reg};
                    end
                end
                BYTE2: begin
                    // Shift in second byte only when capturing a message
                    shift_reg <= {shift_reg[15:0], in_reg};
                end
                BYTE3: begin
                    // Shift in third byte and latch output and done
                    shift_reg <= {shift_reg[15:0], in_reg};
                    out_bytes <= {shift_reg[15:0], in_reg};
                    done <= 1'b1;
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = in_reg[3] ? BYTE2 : IDLE;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule