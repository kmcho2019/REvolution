module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [23:0] out_bytes_reg;
reg done_reg;
reg [1:0] state_reg;
reg [7:0] byte1_reg;
reg [7:0] byte2_reg;

parameter IDLE = 2'b00;
parameter BYTE1 = 2'b01;
parameter BYTE2 = 2'b10;
parameter DONE = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state_reg <= IDLE;
        done_reg <= 1'b0;
        out_bytes_reg <= 24'd0;
        byte1_reg <= 8'd0;
        byte2_reg <= 8'd0;
    end else begin
        case (state_reg)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    state_reg <= BYTE1;
                    byte1_reg <= in;
                end else begin
                    state_reg <= IDLE;
                end
            end
            BYTE1: begin
                state_reg <= BYTE2;
                byte2_reg <= in;
            end
            BYTE2: begin
                state_reg <= DONE;
                out_bytes_reg <= {byte1_reg, byte2_reg, in};
            end
            DONE: begin
                state_reg <= IDLE;
            end
        endcase
        done_reg <= (state_reg == DONE) ? 1'b1 : 1'b0;
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule