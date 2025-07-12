module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] state;    // 0: wait for start, 1: second byte, 2: third byte
    reg [7:0] byte1, byte2;

    always @(posedge clk) begin
        if (reset) begin
            state     <= 2'd0;
            byte1     <= 8'd0;
            byte2     <= 8'd0;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0;  // default done low

            case(state)
                2'd0: begin
                    // Searching for start byte with in[3] == 1
                    if (in[3]) begin
                        byte1 <= in;
                        state <= 2'd1;
                    end
                end
                2'd1: begin
                    byte2 <= in;
                    state <= 2'd2;
                end
                2'd2: begin
                    // Third byte received: output 3-byte message and assert done
                    out_bytes <= {byte1, byte2, in};
                    done      <= 1'b1;
                    state     <= 2'd0;
                end
                default: state <= 2'd0;
            endcase
        end
    end

endmodule