module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [7:0] byte1, byte2, byte3;
reg [1:0] state;
reg done_reg;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00; // IDLE
        done_reg <= 0;
        byte1 <= 8'd0;
        byte2 <= 8'd0;
        byte3 <= 8'd0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (in[3]) begin
                    byte1 <= in;
                    state <= 2'b01; // BYTE1
                end
            end
            2'b01: begin // BYTE1
                byte2 <= in;
                state <= 2'b10; // BYTE2
            end
            2'b10: begin // BYTE2
                byte3 <= in;
                state <= 2'b00; // IDLE
                done_reg <= 1;
            end
            default: state <= 2'b00;
        endcase
        done <= done_reg;
        if (~done_reg) begin
            done_reg <= 0;
        end
    end
end

assign out_bytes = {byte1, byte2, byte3};
assign done = done_reg;

endmodule