module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // State encoding: 2 bits sufficient for 4 states
    localparam IDLE  = 2'b00,
               BYTE1 = 2'b01,
               BYTE2 = 2'b10,
               DONE  = 2'b11;

    reg [1:0] state, next_state;

    reg [7:0] byte1, byte2, byte3;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            byte3 <= 8'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    done <= 1'b0;
                    // Wait for in[3]==1 byte
                    if (in[3]) begin
                        byte1 <= in;
                    end
                end
                BYTE1: begin
                    done <= 1'b0;
                    byte2 <= in;
                end
                BYTE2: begin
                    done <= 1'b0;
                    byte3 <= in;
                end
                DONE: begin
                    done <= 1'b1; // Pulse done here
                    // Latch out_bytes with bytes collected
                    out_bytes <= {byte1, byte2, byte3};
                end
                default: begin
                    done <= 1'b0;
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: next_state = in[3] ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = DONE;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule