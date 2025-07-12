module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

reg [1:0] state; // 0: search, 1: receive byte 1, 2: receive byte 2, 3: receive byte 3
reg [7:0] byte1, byte2, byte3;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done <= 0;
        byte1 <= 0;
        byte2 <= 0;
        byte3 <= 0;
    end else begin
        case (state)
            0: begin // search state
                if (in[3] == 1'b1) begin
                    byte1 <= in;
                    state <= 1;
                end else begin
                    state <= 0; // Stay in search state
                end
            end
            1: begin // receive byte 1
                byte2 <= in;
                state <= 2;
            end
            2: begin // receive byte 2
                byte3 <= in;
                state <= 3;
            end
            3: begin // receive byte 3, signal done
                done <= 1'b1;
                state <= 0; // Return to search state
            end
        endcase
    end
end

always @(posedge clk) begin
    if (!reset && state != 3) begin
        done <= 0; // Clear done signal when not in receive byte 3 state
    end
end

endmodule