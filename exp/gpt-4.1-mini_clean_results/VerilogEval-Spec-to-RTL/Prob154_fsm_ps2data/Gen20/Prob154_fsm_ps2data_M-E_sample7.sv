module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // States encoding
    localparam IDLE      = 2'd0;
    localparam GOT_SYNC  = 2'd1;
    localparam GOT_BYTE2 = 2'd2;
    localparam GOT_BYTE3 = 2'd3;

    reg [1:0] state, next_state;
    reg [23:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            shift_reg <= 24'b0;
            out_bytes <= 24'b0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // default done low

            case (state)
                IDLE: begin
                    // If sync byte detected (in[3]==1), start accumulation
                    if (in[3]) begin
                        shift_reg <= {in, 16'b0}; // Load first byte at MSB
                    end
                end
                GOT_SYNC, GOT_BYTE2: begin
                    // Shift in next byte on each state
                    shift_reg <= {shift_reg[15:0], in};
                end
                GOT_BYTE3: begin
                    // Shift in last byte and output message
                    shift_reg <= {shift_reg[15:0], in};
                    out_bytes <= {shift_reg[15:0], in};
                    done <= 1'b1;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:      next_state = in[3] ? GOT_SYNC : IDLE;
            GOT_SYNC:  next_state = GOT_BYTE2;
            GOT_BYTE2: next_state = GOT_BYTE3;
            GOT_BYTE3: next_state = IDLE;
            default:   next_state = IDLE;
        endcase
    end

endmodule