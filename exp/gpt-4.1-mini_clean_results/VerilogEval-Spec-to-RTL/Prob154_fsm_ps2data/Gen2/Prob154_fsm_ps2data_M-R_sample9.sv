module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  in,
    output reg  [23:0] out_bytes,
    output reg         done
);

    // One-hot state encoding
    localparam WAIT_FOR_START = 3'b001,
               BYTE_2         = 3'b010,
               BYTE_3         = 3'b100;

    reg [2:0] state, next_state;
    reg [23:0] shift_reg;

    // Synchronous state and datapath update
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_FOR_START;
            shift_reg <= 24'b0;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;  // default done deassert

            case (state)
                WAIT_FOR_START: begin
                    if (in[3]) begin
                        // Load first byte into MSB of shift_reg
                        shift_reg <= {in, 16'b0};
                    end
                end
                BYTE_2: begin
                    // Shift in second byte
                    shift_reg <= {shift_reg[15:0], in};
                end
                BYTE_3: begin
                    // Shift in third byte and assert done
                    shift_reg <= {shift_reg[15:0], in};
                    done <= 1'b1;
                    out_bytes <= {shift_reg[23:8], in}; // three bytes concatenated
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        case(state)
            WAIT_FOR_START: next_state = in[3] ? BYTE_2 : WAIT_FOR_START;
            BYTE_2:         next_state = BYTE_3;
            BYTE_3:         next_state = WAIT_FOR_START;
            default:        next_state = WAIT_FOR_START;
        endcase
    end

endmodule