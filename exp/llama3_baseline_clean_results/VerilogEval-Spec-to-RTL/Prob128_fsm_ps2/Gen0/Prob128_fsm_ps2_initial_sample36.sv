module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output done
);

reg [1:0] state;
reg [1:0] nextState;
reg done_reg;

parameter IDLE = 2'b00;
parameter BYTE1 = 2'b01;
parameter BYTE2 = 2'b10;
parameter BYTE3 = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done_reg <= 1'b0;
    end else begin
        state <= nextState;
        done_reg <= (nextState == BYTE3) ? 1'b1 : 1'b0;
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            if (in[3]) begin
                nextState = BYTE1;
            end else begin
                nextState = IDLE;
            end
        end
        BYTE1: begin
            nextState = BYTE2;
        end
        BYTE2: begin
            nextState = BYTE3;
        end
        BYTE3: begin
            nextState = IDLE;
        end
    endcase
end

assign done = done_reg;

endmodule