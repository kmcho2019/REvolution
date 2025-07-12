module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // States:
    // 0: waiting for start byte (in[3]=1)
    // 1: second byte
    // 2: third byte (done next cycle)
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
                        // Load only first byte (MSB) to reduce toggling
                        out_bytes[23:16] <= in;
                        // Keep lower bytes unchanged to minimize switching
                        state <= 2'd1;
                    end
                end

                2'd1: begin
                    // Load second byte (middle)
                    out_bytes[15:8] <= in;
                    // Keep others unchanged
                    state <= 2'd2;
                end

                2'd2: begin
                    // Load third byte (LSB) and assert done this cycle
                    out_bytes[7:0] <= in;
                    done           <= 1'b1;
                    state          <= 2'd0;
                end
            endcase
        end
    end

endmodule