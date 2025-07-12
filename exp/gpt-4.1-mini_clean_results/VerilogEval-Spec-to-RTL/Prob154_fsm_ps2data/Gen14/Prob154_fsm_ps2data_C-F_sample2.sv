module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // FSM states:
    // 0 - waiting for start byte (in[3]=1)
    // 1 - received byte 0 (start byte)
    // 2 - received byte 1
    reg [1:0] state;

    reg [7:0] byte0, byte1, byte2;

    always @(posedge clk) begin
        if (reset) begin
            state     <= 2'd0;
            done      <= 1'b0;
            out_bytes <= 24'd0;
            byte0     <= 8'd0;
            byte1     <= 8'd0;
            byte2     <= 8'd0;
        end else begin
            done <= 1'b0;  // default done low

            case(state)
                2'd0: begin
                    // Waiting for start byte with in[3] = 1
                    if (in[3]) begin
                        byte0 <= in;
                        state <= 2'd1;
                    end
                end
                2'd1: begin
                    // Capture second byte
                    byte1 <= in;
                    state <= 2'd2;
                end
                2'd2: begin
                    // Capture third byte, assert done, and output message
                    byte2 <= in;
                    out_bytes <= {byte0, byte1, in};
                    done <= 1'b1;
                    state <= 2'd0;
                end
                default: state <= 2'd0;
            endcase
        end
    end

endmodule