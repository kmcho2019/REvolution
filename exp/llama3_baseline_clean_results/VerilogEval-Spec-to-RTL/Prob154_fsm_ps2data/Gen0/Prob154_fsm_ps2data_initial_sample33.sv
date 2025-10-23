module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state; // 2-bit state variable
reg [7:0] byte1, byte2, byte3; // registers to store captured bytes

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00; // reset state
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // RESET state
                if (in[3] == 1'b1) begin
                    byte1 <= in;
                    state <= 2'b01; // transition to BYTE1 state
                end
            end
            2'b01: begin // BYTE1 state
                byte2 <= in;
                state <= 2'b10; // transition to BYTE2 state
            end
            2'b10: begin // BYTE2 state
                byte3 <= in;
                state <= 2'b11; // transition to BYTE3 state
            end
            2'b11: begin // BYTE3 state
                done <= 1'b1;
                out_bytes <= {byte1, byte2, byte3}; // output captured bytes
                state <= 2'b00; // transition back to RESET state
            end
            default: state <= 2'b00;
        endcase
    end
end

always @(posedge clk) begin
    if (~done) begin
        done <= 1'b0;
    end
end

endmodule