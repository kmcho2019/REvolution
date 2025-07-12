module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [23:0] msg;
reg [7:0] byte1, byte2, byte3;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE state
        done <= 1'b0;
        out_bytes <= 24'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
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
                state <= 2'b00; // transition back to IDLE state
                done <= 1'b1; // signal receipt of message
                out_bytes <= {byte1, byte2, byte3}; // set out_bytes to 24-bit message
            end
            default: state <= 2'b00;
        endcase
    end
end

always @(posedge clk) begin
    if (!done) begin
        done <= 1'b0;
    end
end

endmodule