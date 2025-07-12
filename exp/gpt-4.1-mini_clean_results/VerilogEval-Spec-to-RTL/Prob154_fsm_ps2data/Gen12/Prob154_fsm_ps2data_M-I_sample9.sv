module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] state;
    reg out_bytes_en;  // Enable signal for updating out_bytes

    always @(posedge clk) begin
        if (reset) begin
            state       <= 2'd0;
            out_bytes   <= 24'd0;
            out_bytes_en <= 1'b0;
        end else begin
            out_bytes_en <= 1'b0; // default disable update
            case(state)
                2'd0: begin
                    if (in[3]) begin
                        // Start new message: store first byte in highest byte
                        out_bytes <= {in, 16'd0};
                        out_bytes_en <= 1'b1;
                        state     <= 2'd1;
                    end
                end
                2'd1: begin
                    // Capture second byte in middle byte
                    out_bytes <= {out_bytes[23:16], in, 8'd0};
                    out_bytes_en <= 1'b1;
                    state     <= 2'd2;
                end
                2'd2: begin
                    // Capture third byte in lowest byte, prepare to assert done
                    out_bytes <= {out_bytes[23:8], in};
                    out_bytes_en <= 1'b1;
                    state     <= 2'd0;
                end
            endcase
        end
    end

    // Update out_bytes only when enabled to reduce toggling
    always @(posedge clk) begin
        if (reset) begin
            out_bytes <= 24'd0;
        end else if (out_bytes_en) begin
            // out_bytes already updated in previous always block with non-blocking assignment,
            // so this always block just to confirm no extra toggling, can be removed,
            // but here for clarity and possible clock gating in physical implementation.
        end
    end

    // Separate done register for glitch-free timing
    reg done_next;
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            done_next <= 1'b0;
        end else begin
            done <= done_next;
            // done asserted only one cycle after receiving 3rd byte
            done_next <= (state == 2'd2);
        end
    end

endmodule