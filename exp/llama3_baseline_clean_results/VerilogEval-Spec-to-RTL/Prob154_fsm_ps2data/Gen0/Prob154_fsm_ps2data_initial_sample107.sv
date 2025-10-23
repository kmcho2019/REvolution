module TopModule (
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [23:0] out_bytes_reg;
reg [1:0] state;
reg [1:0] next_state;
reg done_reg;

parameter IDLE = 2'b00;
parameter BYTE1 = 2'b01;
parameter BYTE2 = 2'b10;
parameter DONE = 2'b11;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        out_bytes_reg <= 24'b0;
        done_reg <= 1'b0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    out_bytes_reg[7:0] <= in;
                    next_state <= BYTE1;
                end else begin
                    next_state <= IDLE;
                end
            end
            BYTE1: begin
                out_bytes_reg[15:8] <= in;
                next_state <= BYTE2;
            end
            BYTE2: begin
                out_bytes_reg[23:16] <= in;
                next_state <= DONE;
            end
            DONE: begin
                done_reg <= 1'b1;
                next_state <= IDLE;
            end
        endcase
    end
end

assign out_bytes = (done_reg) ? out_bytes_reg : 24'b0;
assign done = done_reg;

always @(posedge clk) begin
    if (state == DONE) begin
        done_reg <= 1'b0;
    end
end

endmodule