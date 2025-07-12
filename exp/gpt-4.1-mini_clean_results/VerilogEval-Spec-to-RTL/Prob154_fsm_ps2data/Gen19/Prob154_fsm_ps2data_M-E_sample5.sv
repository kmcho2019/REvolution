module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // One-hot state encoding
    localparam IDLE       = 3'b001; // waiting for sync byte (in[3] == 1)
    localparam COLLECT_2  = 3'b010; // received first byte, waiting for 2nd
    localparam COLLECT_3  = 3'b100; // received second byte, waiting for 3rd

    reg [2:0] state, next_state;

    // Shift register to hold incoming message bytes
    reg [23:0] shift_reg;

    // FSM sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            shift_reg <= 24'd0;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // default done low every cycle

            case (state)
                IDLE: begin
                    // Look for sync byte: in[3]==1
                    if (in[3]) begin
                        shift_reg <= {in, 16'd0}; // load first byte into MSByte of shift_reg
                    end
                end
                COLLECT_2: begin
                    // Shift in second byte: shift existing bytes left by 8 bits, add new byte at LSB
                    shift_reg <= {shift_reg[15:0], in};
                end
                COLLECT_3: begin
                    // Shift in third byte similarly
                    shift_reg <= {shift_reg[15:0], in};
                    out_bytes <= {shift_reg[15:0], in}; // output complete 3-byte message
                    done <= 1'b1;                        // signal done in this cycle
                end
                default: begin
                    // Should not occur; safe default
                    shift_reg <= 24'd0;
                    done <= 1'b0;
                end
            endcase
        end
    end

    // Next-state combinational logic
    always @(*) begin
        case (state)
            IDLE:      next_state = (in[3]) ? COLLECT_2 : IDLE;
            COLLECT_2: next_state = COLLECT_3;
            COLLECT_3: next_state = IDLE;
            default:   next_state = IDLE;
        endcase
    end

endmodule