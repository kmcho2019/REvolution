module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output done
);

    // States for FSM
    localparam IDLE   = 2'd0;
    localparam BYTE_2 = 2'd1;
    localparam BYTE_3 = 2'd2;

    reg [1:0] state, next_state;
    reg [23:0] shift_reg; // Holds three bytes: [23:16] oldest, [15:8] middle, [7:0] newest

    // Output done combinationally when in BYTE_3 state
    assign done = (state == BYTE_3);

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:   next_state = (in[3]) ? BYTE_2 : IDLE;
            BYTE_2: next_state = BYTE_3;
            BYTE_3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state update and shift register load
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 24'd0;
            out_bytes <= 24'd0;
        end else begin
            state <= next_state;
            case(next_state)
                IDLE: begin
                    // In IDLE, shift_reg not updated unless starting new message
                    if (in[3]) begin
                        // Initialize shift_reg with first byte, zero the rest
                        shift_reg <= {in, 16'd0};
                    end
                end
                BYTE_2: begin
                    // Shift in second byte: shift left by 8 bits, insert new byte at low bits
                    shift_reg <= {shift_reg[15:0], in};
                end
                BYTE_3: begin
                    // Shift in third byte and update output
                    shift_reg <= {shift_reg[15:0], in};
                    out_bytes <= {shift_reg[15:0], in}; // Output concatenated 3 bytes
                end
                default: ;
            endcase
        end
    end

endmodule