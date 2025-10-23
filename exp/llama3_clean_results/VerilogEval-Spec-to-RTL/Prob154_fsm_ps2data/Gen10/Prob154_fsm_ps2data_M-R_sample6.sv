module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state;
reg [1:0] next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Initialize to idle state
        out_bytes <= 24'b0;
        done <= 1'b0;
    end else begin
        state <= next_state;
        case (state)
            2'b00: begin // Idle state
                if (in[3] == 1'b1) begin
                    out_bytes[23:16] <= in;
                    next_state <= 2'b01; // Transition to byte1 state
                end else begin
                    next_state <= 2'b00; // Stay in idle state
                end
            end
            2'b01: begin // Byte1 state
                out_bytes[15:8] <= in;
                next_state <= 2'b10; // Transition to byte2 state
            end
            2'b10: begin // Byte2 state
                out_bytes[7:0] <= in;
                next_state <= 2'b00; // Transition back to idle state
            end
            default: begin
                next_state <= 2'b00; // Reset to idle state
            end
        endcase
    end
end

assign done = (state == 2'b10)? 1'b1 : 1'b0;

endmodule