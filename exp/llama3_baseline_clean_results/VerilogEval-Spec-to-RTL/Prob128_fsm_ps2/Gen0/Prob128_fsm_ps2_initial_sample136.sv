module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

reg [1:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE state
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3] == 1'b1) begin
                    state <= 2'b01; // BYTE1 state
                end
                done <= 1'b0;
            end
            2'b01: begin // BYTE1 state
                state <= 2'b10; // BYTE2 state
                done <= 1'b0;
            end
            2'b10: begin // BYTE2 state
                state <= 2'b11; // BYTE3 state
                done <= 1'b0;
            end
            2'b11: begin // BYTE3 state
                done <= 1'b1;
                state <= 2'b00; // IDLE state
            end
        endcase
    end
end

endmodule