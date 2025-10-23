module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // State encoding:
    // 0 - waiting for start byte (in[3]=1)
    // 1 - received first byte
    // 2 - received second byte, waiting for third byte
    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state     <= 2'd0;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0; // default done low each cycle
            case(state)
                2'd0: begin
                    if (in[3]) begin
                        // Start new message: store first byte in highest byte
                        out_bytes <= {in, 16'd0};
                        state     <= 2'd1;
                    end
                end
                2'd1: begin
                    // Capture second byte in middle byte
                    out_bytes <= {out_bytes[23:16], in, 8'd0};
                    state     <= 2'd2;
                end
                2'd2: begin
                    // Capture third byte in lowest byte, assert done
                    out_bytes <= {out_bytes[23:8], in};
                    done      <= 1'b1;
                    state     <= 2'd0;
                end
            endcase
        end
    end

endmodule