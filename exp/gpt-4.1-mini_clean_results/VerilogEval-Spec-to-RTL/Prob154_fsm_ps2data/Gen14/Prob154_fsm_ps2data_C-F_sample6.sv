module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // FSM states:
    // 0 = waiting for start byte (in[3]=1)
    // 1 = received byte 1 (start byte)
    // 2 = received byte 2
    reg [1:0] state;

    // Store each byte separately to avoid shifting full 24-bit reg every cycle
    reg [7:0] byte1;
    reg [7:0] byte2;
    reg [7:0] byte3;

    always @(posedge clk) begin
        if (reset) begin
            state    <= 2'd0;
            byte1    <= 8'd0;
            byte2    <= 8'd0;
            byte3    <= 8'd0;
            done     <= 1'b0;
            out_bytes <= 24'd0;
        end else begin
            done <= 1'b0; // default done low

            case(state)
                2'd0: begin
                    // Wait for start byte
                    if (in[3]) begin
                        byte1 <= in;
                        state <= 2'd1;
                    end
                end

                2'd1: begin
                    // Receive second byte
                    byte2 <= in;
                    state <= 2'd2;
                end

                2'd2: begin
                    // Receive third byte and assert done
                    byte3 <= in;
                    done  <= 1'b1;
                    state <= 2'd0;
                end
            endcase

            // Assemble out_bytes combinationally from stored bytes
            out_bytes <= {byte1, byte2, byte3};
        end
    end

endmodule