module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state     <= 2'd0;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0; // default done low

            case(state)
                2'd0: begin
                    if (in[3]) begin
                        // Load first byte only if in[3] == 1
                        out_bytes[23:16] <= in;
                        // Keep other bytes unchanged to reduce toggling
                        // (they are zero after reset)
                        state <= 2'd1;
                    end
                end

                2'd1: begin
                    // Load second byte only
                    out_bytes[15:8] <= in;
                    // Keep other bytes unchanged
                    state <= 2'd2;
                end

                2'd2: begin
                    // Load third byte and assert done
                    out_bytes[7:0] <= in;
                    done           <= 1'b1;
                    state          <= 2'd0;
                end
            endcase
        end
    end

endmodule