module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // State encoding:
    // 0: Waiting for start byte (in[3] == 1)
    // 1: Received first byte, wait for second byte
    // 2: Received second byte, wait for third byte
    reg [1:0] state;

    // Internal signal to assert done exactly one cycle after third byte reception
    reg done_reg;

    always @(posedge clk) begin
        if (reset) begin
            state      <= 2'd0;
            out_bytes  <= 24'd0;
            done       <= 1'b0;
            done_reg   <= 1'b0;
        end else begin
            done <= done_reg;
            done_reg <= 1'b0; // default clear done after one cycle pulse

            case(state)
                2'd0: begin
                    // Waiting for start byte
                    if (in[3]) begin
                        // Capture first byte in MSB part, keep others unchanged
                        out_bytes[23:16] <= in;
                        // No change to lower bytes
                        state <= 2'd1;
                    end
                end

                2'd1: begin
                    // Capture second byte in middle 8 bits
                    out_bytes[15:8] <= in;
                    // Preserve other bytes
                    state <= 2'd2;
                end

                2'd2: begin
                    // Capture third byte in LSB
                    out_bytes[7:0] <= in;
                    // Signal done in next cycle to separate data and done timing paths
                    done_reg <= 1'b1;
                    state <= 2'd0;
                end

                default: begin
                    state <= 2'd0; // safety fallback
                end
            endcase
        end
    end

endmodule