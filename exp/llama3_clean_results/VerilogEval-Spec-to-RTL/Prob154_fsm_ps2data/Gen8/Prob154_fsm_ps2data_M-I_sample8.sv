module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [2:0] state; // one-hot encoding
reg [23:0] out_bytes_next;

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b001; // initial state: idle
        out_bytes <= 0;
        done <= 0;
    end else begin
        case (state)
            3'b001: begin // idle state
                if (in[3] == 1'b1) begin
                    out_bytes_next[23:16] <= in;
                    state <= 3'b010; // transition to byte1 state
                end else begin
                    state <= 3'b001; // stay in idle state
                end
                done <= 1'b0;
            end
            3'b010: begin // byte1 state
                out_bytes_next[15:8] <= in;
                state <= 3'b100; // transition to byte2 state
                done <= 1'b0;
            end
            3'b100: begin // byte2 state
                out_bytes_next[7:0] <= in;
                state <= 3'b001; // transition back to idle state
                done <= 1'b1;
            end
            default: begin
                state <= 3'b001; // default to idle state
                done <= 1'b0;
            end
        endcase
        out_bytes <= out_bytes_next;
    end
end

endmodule