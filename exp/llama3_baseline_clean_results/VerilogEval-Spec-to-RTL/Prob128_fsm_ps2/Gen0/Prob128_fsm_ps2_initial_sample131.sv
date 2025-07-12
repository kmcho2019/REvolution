module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state;
reg [7:0] byte1, byte2, byte3;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE state
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3] == 1'b1) begin
                    state <= 2'b01; // BYTE1 state
                    byte1 <= in;
                end
            end
            2'b01: begin // BYTE1 state
                state <= 2'b10; // BYTE2 state
                byte2 <= in;
            end
            2'b10: begin // BYTE2 state
                state <= 2'b11; // BYTE3 state
                byte3 <= in;
            end
            2'b11: begin // BYTE3 state
                state <= 2'b00; // IDLE state
                done <= 1'b1;
            end
        endcase
    end
end

endmodule