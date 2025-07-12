module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // State encoding
    localparam WAIT_FOR_START = 2'd0,
               READ_BYTE2     = 2'd1,
               READ_BYTE3     = 2'd2,
               DONE_SIGNAL    = 2'd3;

    reg [1:0] state, next_state;
    reg [23:0] shift_reg;  // holds the 3-byte message: MSB first byte, LSB last byte

    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_FOR_START;
            shift_reg <= 24'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default done low unless asserted below

            case(state)
                WAIT_FOR_START: begin
                    // Wait for start byte (in[3] == 1)
                    if (in[3]) begin
                        // Insert start byte as MSB of shift_reg, clearing lower bytes
                        shift_reg <= {in, 16'd0};
                    end
                end
                READ_BYTE2: begin
                    // Shift left 8 bits and insert byte2 into lower 16 bits
                    shift_reg <= {shift_reg[15:0], in};
                end
                READ_BYTE3: begin
                    // Shift left 8 bits and insert byte3 into lower 8 bits
                    shift_reg <= {shift_reg[15:0], in};
                end
                DONE_SIGNAL: begin
                    done <= 1'b1;
                    out_bytes <= shift_reg;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            WAIT_FOR_START: next_state = in[3] ? READ_BYTE2 : WAIT_FOR_START;
            READ_BYTE2:     next_state = READ_BYTE3;
            READ_BYTE3:     next_state = DONE_SIGNAL;
            DONE_SIGNAL:    next_state = WAIT_FOR_START;
            default:        next_state = WAIT_FOR_START;
        endcase
    end

endmodule