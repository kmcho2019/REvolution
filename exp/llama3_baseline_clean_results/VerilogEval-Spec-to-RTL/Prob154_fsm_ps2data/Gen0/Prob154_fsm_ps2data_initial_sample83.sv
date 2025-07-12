module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state;
reg [7:0] byte1, byte2;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE state
        done <= 0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3]) begin
                    byte1 <= in;
                    state <= 2'b01; // Transition to BYTE_1 state
                end
            end
            2'b01: begin // BYTE_1 state
                byte2 <= in;
                out_bytes[15:8] <= byte1;
                out_bytes[7:0] <= in;
                state <= 2'b10; // Transition to BYTE_2 state
            end
            2'b10: begin // BYTE_2 state
                done <= 1;
                out_bytes[23:16] <= byte1;
                out_bytes[15:8] <= byte2;
                out_bytes[7:0] <= in;
                state <= 2'b00; // Transition back to IDLE state
            end
        endcase
        if (state != 2'b10) begin
            done <= 0;
        end
    end
end

endmodule