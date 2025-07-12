module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state;
reg [1:0] nextState;

parameter IDLE = 2'b00;
parameter BYTE1 = 2'b01;
parameter BYTE2 = 2'b10;
parameter BYTE3 = 2'b11;

always @(*)
begin
    case (state)
        IDLE:
            if (in[3] == 1'b1)
                nextState = BYTE1;
            else
                nextState = IDLE;
        BYTE1:
            nextState = BYTE2;
        BYTE2:
            nextState = BYTE3;
        BYTE3:
            nextState = IDLE;
        default:
            nextState = IDLE;
    endcase
end

always @(posedge clk)
begin
    if (reset)
        state <= IDLE;
    else
        state <= nextState;
end

always @(posedge clk)
begin
    if (state == BYTE3)
        done <= 1'b1;
    else
        done <= 1'b0;
end

endmodule