module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // One-hot FSM state bits
    localparam IDLE  = 4'b0001;
    localparam BYTE1 = 4'b0010;
    localparam BYTE2 = 4'b0100;
    localparam DONE  = 4'b1000;

    reg [3:0] state, next_state;
    reg [23:0] shift_reg;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            shift_reg <= 24'd0;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0;  // default done low

            case (state)
                IDLE: begin
                    // Wait for sync byte (in[3] == 1)
                    if (in[3]) begin
                        // Load first byte into MSB position
                        shift_reg <= {in, 16'd0};
                    end
                end
                BYTE1: begin
                    // Shift in second byte
                    shift_reg <= {shift_reg[15:0], in};
                end
                BYTE2: begin
                    // Shift in third byte
                    shift_reg <= {shift_reg[15:0], in};
                end
                DONE: begin
                    // Output the assembled 3-byte message
                    out_bytes <= shift_reg;
                    done      <= 1'b1;
                end
                default: begin
                    // Safety fallback
                    shift_reg <= 24'd0;
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        case (state)
            IDLE:  next_state = (in[3]) ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = DONE;
            DONE:  next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule