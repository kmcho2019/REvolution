module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [7:0] byte1, byte2, byte3;
reg [1:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE state
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3] == 1'b1) begin
                    byte1 <= in;
                    state <= 2'b01; // transition to BYTE1 state
                end
                done <= 1'b0;
            end
            2'b01: begin // BYTE1 state
                byte2 <= in;
                state <= 2'b10; // transition to BYTE2 state
                done <= 1'b0;
            end
            2'b10: begin // BYTE2 state
                byte3 <= in;
                state <= 2'b00; // transition back to IDLE state
                done <= 1'b1;
            end
        endcase
    end
end

always @(*) begin
    out_bytes = {byte1, byte2, byte3};
end

endmodule