module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state;
reg done_reg;

parameter IDLE = 2'b00;
parameter BYTE1 = 2'b01;
parameter BYTE2 = 2'b10;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done_reg <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    state <= BYTE1;
                end
            end
            BYTE1: begin
                state <= BYTE2;
            end
            BYTE2: begin
                done_reg <= 1'b1;
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
end

assign done = done_reg;

always @(posedge clk) begin
    if (~reset) begin
        done_reg <= 1'b0;
    end
end

endmodule