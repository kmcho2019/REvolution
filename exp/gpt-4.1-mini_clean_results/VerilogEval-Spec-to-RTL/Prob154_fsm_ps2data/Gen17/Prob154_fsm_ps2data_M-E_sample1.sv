module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // FSM States
    localparam IDLE  = 2'd0,
               BYTE1 = 2'd1,
               BYTE2 = 2'd2,
               BYTE3 = 2'd3;

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0; // Default done low each cycle

            case (state)
                IDLE: begin
                    if (in[3]) begin
                        // Start byte detected: shift bytes left, insert new byte at LSB
                        out_bytes <= {16'd0, in};
                        state <= BYTE1;
                    end
                end

                BYTE1: begin
                    // Shift bytes left by 8 bits, insert new byte at LSB
                    out_bytes <= {out_bytes[15:0], in};
                    state <= BYTE2;
                end

                BYTE2: begin
                    // Shift bytes left by 8 bits, insert new byte at LSB
                    out_bytes <= {out_bytes[15:0], in};
                    state <= BYTE3;
                end

                BYTE3: begin
                    // Assert done to signal complete message
                    done <= 1'b1;
                    // Stay ready for next message, back to IDLE
                    state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule