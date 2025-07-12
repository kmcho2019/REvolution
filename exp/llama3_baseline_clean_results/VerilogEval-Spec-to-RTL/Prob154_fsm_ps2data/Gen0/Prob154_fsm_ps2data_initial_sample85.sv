module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [23:0] out_bytes_reg;
reg done_reg;
reg [7:0] byte1, byte2;
reg [1:0] state;

parameter IDLE = 2'b00, BYTE1 = 2'b01, BYTE2 = 2'b10, DONE = 2'b11;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        done_reg <= 1'b0;
        out_bytes_reg <= 24'd0;
    end else begin
        case (state)
            IDLE: begin
                if (in[3]) begin
                    byte1 <= in;
                    state <= BYTE1;
                end else begin
                    state <= IDLE;
                end
                done_reg <= 1'b0;
            end
            BYTE1: begin
                byte2 <= in;
                state <= BYTE2;
            end
            BYTE2: begin
                out_bytes_reg <= {byte1, byte2, in};
                state <= DONE;
            end
            DONE: begin
                done_reg <= 1'b1;
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
end

assign done = done_reg;
assign out_bytes = out_bytes_reg;

endmodule