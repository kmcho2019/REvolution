module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // State encoding
    localparam IDLE  = 2'd0,
               BYTE2 = 2'd1,
               BYTE3 = 2'd2;

    reg [1:0] state, next_state;
    reg [7:0] in_reg;
    reg [23:0] shift_reg;

    // Register input to reduce combinational path
    always @(posedge clk) begin
        if (reset) begin
            in_reg <= 8'd0;
        end else begin
            in_reg <= in;
        end
    end

    // FSM state and datapath
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
                    // Only load shift_reg if start byte found
                    if (in_reg[3]) begin
                        shift_reg <= {16'd0, in_reg};
                    end
                end
                BYTE2: begin
                    // Shift and add next byte only when in BYTE2 or BYTE3
                    shift_reg <= {shift_reg[15:0], in_reg};
                end
                BYTE3: begin
                    shift_reg <= {shift_reg[15:0], in_reg};
                    out_bytes <= {shift_reg[15:0], in_reg};
                    done <= 1'b1;
                end
                default: ;
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:  next_state = in_reg[3] ? BYTE2 : IDLE;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule