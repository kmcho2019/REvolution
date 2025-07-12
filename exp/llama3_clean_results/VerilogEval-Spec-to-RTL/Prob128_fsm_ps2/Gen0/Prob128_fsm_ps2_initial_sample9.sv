module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

reg [1:0] state; // 0: searching for first byte, 1: received first byte, 2: received second byte
reg [7:0] byte1, byte2, byte3; // registers to hold the bytes of the message

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to searching state
        done <= 0;
    end else begin
        case(state)
            0: begin // Searching for first byte
                if (in[3] == 1'b1) begin
                    byte1 <= in;
                    state <= 1;
                end else begin
                    state <= 0; // Stay in searching state
                end
            end
            1: begin // Received first byte, looking for second
                byte2 <= in;
                state <= 2;
            end
            2: begin // Received second byte, looking for third
                byte3 <= in;
                state <= 0; // Transition back to searching after receiving third byte
                done <= 1'b1; // Signal done after receiving third byte
            end
            default: state <= 0; // Default, should not occur
        endcase
    end
end

// Add a reset at the beginning to avoid any unexpected behavior
initial begin
    state <= 0;
    done <= 0;
end

endmodule