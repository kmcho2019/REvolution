module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

reg [1:0] state; // 2-bit state register
parameter Idle = 2'b00, Byte1 = 2'b01, Byte2 = 2'b10, Done = 2'b11;

always @(posedge clk) begin
    if (reset) begin // Reset to Idle state
        state <= Idle;
        done <= 1'b0;
    end else begin
        case (state)
            Idle: begin
                if (in[3] == 1'b1) begin // Check for byte with in[3] = 1
                    state <= Byte1;
                end
            end
            Byte1: begin
                state <= Byte2;
            end
            Byte2: begin
                state <= Done;
            end
            Done: begin
                done <= 1'b1; // Assert 'done' signal
                if (in[3] == 1'b1) begin // Check for next message
                    state <= Byte1;
                end else begin
                    state <= Idle;
                end
                done <= 1'b0; // Deassert 'done' signal after one cycle
            end
        endcase
    end
end

endmodule