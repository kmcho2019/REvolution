module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // State encoding as one-hot for clarity
    localparam IDLE  = 3'b001;
    localparam BYTE1 = 3'b010;
    localparam BYTE2 = 3'b100;

    reg [2:0] state, next_state;
    reg [23:0] shift_reg;

    // State register and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 24'b0;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default done deassert

            case(state)
                IDLE: begin
                    if (in[3]) begin
                        shift_reg <= {in, 16'b0};  // load first byte into MSB of 24-bit register
                    end
                end
                BYTE1: begin
                    // Shift previous byte left by 8 and insert new byte in lower 16 bits
                    shift_reg <= {shift_reg[15:0], in};
                end
                BYTE2: begin
                    // Shift again to bring in third byte
                    shift_reg <= {shift_reg[15:0], in};
                    done <= 1'b1;
                    out_bytes <= {shift_reg[15:8], shift_reg[7:0], in}; // reconstruct message for output
                    // We reconstruct the output because shift_reg does not hold the last byte yet when done is asserted
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (in[3])
                    next_state = BYTE1;
                else
                    next_state = IDLE;
            end
            BYTE1: begin
                next_state = BYTE2;
            end
            BYTE2: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule