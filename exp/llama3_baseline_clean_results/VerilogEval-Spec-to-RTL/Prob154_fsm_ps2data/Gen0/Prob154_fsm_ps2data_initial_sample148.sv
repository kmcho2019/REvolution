module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state; // 0: waiting for start byte, 1: received start byte, 2: received second byte
reg [7:0] byte1, byte2; // Storage for the first and second bytes of the message

always @ (posedge clk) begin
    if (reset) begin // Reset condition
        state <= 0;
        out_bytes <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // Waiting for start byte
                if (in[3] == 1) begin // Found start byte
                    byte1 <= in;
                    state <= 1;
                end
            end
            1: begin // Received start byte, waiting for second byte
                byte2 <= in;
                state <= 2;
            end
            2: begin // Received second byte, waiting for third byte
                out_bytes <= {byte1, byte2, in}; // Assemble the 24-bit message
                done <= 1; // Signal message received
                state <= 0; // Reset state for next message
            end
            default: state <= 0;
        endcase
    end
end

always @ (posedge clk) begin
    if (~done) begin // Done signal is only high for one cycle
        done <= 0;
    end
end

endmodule