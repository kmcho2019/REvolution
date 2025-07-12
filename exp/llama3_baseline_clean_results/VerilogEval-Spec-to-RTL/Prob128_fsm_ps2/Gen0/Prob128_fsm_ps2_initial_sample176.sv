module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output done
);

reg [1:0] state;
reg [1:0] nextState;
reg doneReg;
reg [7:0] byte1, byte2, byte3;

always @(*)
begin
    case(state)
        2'b00: // IDLE state
            if(in[3] == 1'b1)
                nextState = 2'b01;
            else
                nextState = 2'b00;
        2'b01: // BYTE1 state
            nextState = 2'b10;
        2'b10: // BYTE2 state
            nextState = 2'b00;
    endcase
end

always @(posedge clk)
begin
    if(reset)
    begin
        state <= 2'b00;
        doneReg <= 1'b0;
    end
    else
    begin
        state <= nextState;
        case(state)
            2'b00: // IDLE state
                byte1 <= 8'b0;
                byte2 <= 8'b0;
                byte3 <= 8'b0;
            2'b01: // BYTE1 state
                byte1 <= in;
            2'b10: // BYTE2 state
                byte2 <= in;
                byte3 <= in;
        endcase
        if(state == 2'b10 && nextState == 2'b00)
            doneReg <= 1'b1;
        else
            doneReg <= 1'b0;
    end
end

assign done = doneReg;

endmodule