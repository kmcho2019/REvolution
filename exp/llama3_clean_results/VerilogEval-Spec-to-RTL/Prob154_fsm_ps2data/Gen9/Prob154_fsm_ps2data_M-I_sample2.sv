module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [2:0] state; // one-hot encoding
reg [23:0] temp_out_bytes;

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b001; // initial state: Idle
        out_bytes <= 0;
        done <= 0;
    end else begin
        case (state)
            3'b001: begin // Idle
                if (in[3] == 1'b1) begin
                    temp_out_bytes[23:16] <= in;
                    state <= 3'b010; // transition to Byte1
                end
                done <= 1'b0;
            end
            3'b010: begin // Byte1
                temp_out_bytes[15:8] <= in;
                state <= 3'b100; // transition to Byte2
                done <= 1'b0;
            end
            3'b100: begin // Byte2
                temp_out_bytes[7:0] <= in;
                out_bytes <= temp_out_bytes; // update out_bytes
                state <= 3'b001; // transition back to Idle
                done <= 1'b1;
            end
            default: begin
                state <= 3'b001; // default to Idle state
                done <= 1'b0;
            end
        endcase
    end
end

endmodule