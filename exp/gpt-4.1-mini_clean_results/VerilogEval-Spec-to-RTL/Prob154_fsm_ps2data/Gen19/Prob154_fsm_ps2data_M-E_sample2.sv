module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // One-hot encoding states
    localparam WAIT_START = 4'b0001,
               BYTE1      = 4'b0010,
               BYTE2      = 4'b0100,
               DONE_SIGNAL= 4'b1000;

    reg [3:0] state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_START;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // default done low

            case(state)
                WAIT_START: begin
                    if (in[3]) begin
                        // latch first byte in MSB
                        out_bytes[23:16] <= in;
                    end
                end
                BYTE1: begin
                    out_bytes[15:8] <= in;  // second byte
                end
                BYTE2: begin
                    out_bytes[7:0] <= in;   // third byte
                end
                DONE_SIGNAL: begin
                    done <= 1'b1;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            WAIT_START: begin
                if (in[3]) 
                    next_state = BYTE1;
                else
                    next_state = WAIT_START;
            end
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = DONE_SIGNAL;
            DONE_SIGNAL: next_state = WAIT_START;
            default: next_state = WAIT_START;
        endcase
    end

endmodule