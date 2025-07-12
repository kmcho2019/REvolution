module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  [23:0]  out_bytes,
    output          done
);

reg [23:0] out_bytes_reg;
reg         done_reg;

reg [1:0] state;
reg [1:0] next_state;

parameter IDLE = 2'b00;
parameter BYTE1 = 2'b01;
parameter BYTE2 = 2'b10;
parameter DONE = 2'b11;

always @(*) begin
    case(state)
        IDLE: begin
            if(in[3] == 1'b1) begin
                out_bytes_reg = {in, 16'b0};
                next_state = BYTE1;
            end else begin
                next_state = IDLE;
            end
        end
        BYTE1: begin
            out_bytes_reg = {out_bytes_reg[15:0], in};
            next_state = BYTE2;
        end
        BYTE2: begin
            out_bytes_reg = {out_bytes_reg[15:0], in};
            next_state = DONE;
        end
        DONE: begin
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= IDLE;
        done_reg <= 1'b0;
        out_bytes_reg <= 24'b0;
    end else begin
        state <= next_state;
        if(next_state == DONE) begin
            done_reg <= 1'b1;
        end else begin
            done_reg <= 1'b0;
        end
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule