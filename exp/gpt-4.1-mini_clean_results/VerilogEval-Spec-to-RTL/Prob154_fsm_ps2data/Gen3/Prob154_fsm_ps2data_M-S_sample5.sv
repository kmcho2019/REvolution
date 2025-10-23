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
    reg [23:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 24'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;  // default no done

            case(state)
                IDLE: begin
                    if (in[3]) begin
                        shift_reg <= {16'd0, in};
                    end
                end
                BYTE2: begin
                    shift_reg <= {shift_reg[15:0], in};
                end
                BYTE3: begin
                    shift_reg <= {shift_reg[15:0], in};
                    out_bytes <= {shift_reg[15:0], in};
                    done <= 1'b1;
                end
            endcase
        end
    end

    always @(*) begin
        case(state)
            IDLE:  next_state = in[3] ? BYTE2 : IDLE;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule