module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // FSM state encoding
    // 0: waiting for start byte (in[3]=1)
    // 1: received first byte
    // 2: received second byte
    reg [1:0] state;

    // Enable signal for out_bytes update
    reg out_en;

    always @(posedge clk) begin
        if (reset) begin
            state     <= 2'd0;
            out_bytes <= 24'd0;
            done      <= 1'b0;
            out_en    <= 1'b0;
        end else begin
            done   <= 1'b0; // default done low

            case(state)
                2'd0: begin
                    out_en <= 1'b0;
                    if (in[3]) begin
                        // Start byte detected, load highest byte
                        state  <= 2'd1;
                        out_en <= 1'b1;
                    end
                end
                2'd1: begin
                    // Capture second byte
                    state  <= 2'd2;
                    out_en <= 1'b1;
                end
                2'd2: begin
                    // Capture third byte and assert done next cycle
                    state  <= 2'd0;
                    done   <= 1'b1;
                    out_en <= 1'b1;
                end
                default: begin
                    state  <= 2'd0;
                    out_en <= 1'b0;
                    done   <= 1'b0;
                end
            endcase

            // Update out_bytes only when out_en is high
            if (out_en) begin
                case(state)
                    2'd0: begin
                        // After done, and reset or waiting, no update
                    end
                    2'd1: begin
                        // first byte received: place in highest byte, zero rest
                        out_bytes <= {in, 16'd0};
                    end
                    2'd2: begin
                        // second byte received: shift previous first byte down, insert in middle byte
                        out_bytes <= {out_bytes[23:16], in, 8'd0};
                    end
                    2'd0: begin
                        // third byte received: shift previous two bytes down, insert lowest byte
                        // this is handled before state changes, so safe to update here
                        // Actually, state just transitioned to 0, but we want to update on previous state 2
                        // So handle update in state 2 block, below
                    end
                endcase
            end

            // To handle third byte update correctly, do it separately
            if (state == 2'd2 && out_en) begin
                // On state 2 cycle, update with third byte
                out_bytes <= {out_bytes[23:8], in};
            end
        end
    end

endmodule