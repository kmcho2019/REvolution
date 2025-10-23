module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // One-hot state encoding
    localparam WAIT_START = 3'b001;
    localparam BYTE_2     = 3'b010;
    localparam BYTE_3     = 3'b100;

    reg [2:0] state, next_state;

    reg [23:0] msg_shift; // Shift register holding 3 bytes

    // Sequential logic: state transitions, byte capture, and outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_START;
            msg_shift <= 24'b0;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // Default done low; set later if needed

            case (state)
                WAIT_START: begin
                    // Wait for start byte where in[3] == 1
                    if (in[3]) begin
                        // Capture first byte into MSB byte of shift register
                        msg_shift <= {in, 16'b0};
                    end else begin
                        msg_shift <= msg_shift; // Hold value; could be don't care
                    end
                end
                BYTE_2: begin
                    // Shift left by 8 bits and load second byte into middle byte
                    msg_shift <= {msg_shift[15:0], in};
                end
                BYTE_3: begin
                    // Shift left by 8 bits and load third byte
                    msg_shift <= {msg_shift[15:0], in};
                    out_bytes <= {msg_shift[23:16], msg_shift[15:8], in};
                    done <= 1'b1;
                end
                default: begin
                    msg_shift <= 24'b0;
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            WAIT_START: begin
                if (in[3])
                    next_state = BYTE_2;
                else
                    next_state = WAIT_START;
            end
            BYTE_2: next_state = BYTE_3;
            BYTE_3: next_state = WAIT_START;
            default: next_state = WAIT_START;
        endcase
    end

endmodule