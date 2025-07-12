module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    // State encoding: 2-bit binary
    // 0: waiting for start byte (in[3] = 1)
    // 1: received first byte
    // 2: received second byte
    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default no done
            case (state)
                2'b00: begin
                    if (in[3]) begin
                        // First byte found, move to state 1
                        state <= 2'b01;
                    end
                end
                2'b01: begin
                    // Received first byte, move to second byte
                    state <= 2'b10;
                end
                2'b10: begin
                    // Received second byte, next is third byte -> done next cycle
                    state <= 2'b00;
                    done <= 1'b1; // done asserted after third byte received
                end
                default: begin
                    state <= 2'b00;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule