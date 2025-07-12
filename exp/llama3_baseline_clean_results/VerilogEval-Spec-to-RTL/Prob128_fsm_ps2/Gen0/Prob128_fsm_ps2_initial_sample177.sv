module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state;
reg [1:0] nextState;
reg doneReg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00; // IDLE state
        doneReg <= 1'b0;
    end else begin
        state <= nextState;
        doneReg <= 1'b0;
        if (nextState == 2'b11) begin // BYTE3 state
            doneReg <= 1'b1;
        end
    end
end

always @(*) begin
    case (state)
        2'b00: begin // IDLE state
            if (in[3] == 1'b1) begin
                nextState = 2'b01; // BYTE1 state
            end else begin
                nextState = 2'b00; // stay in IDLE state
            end
        end
        2'b01: begin // BYTE1 state
            nextState = 2'b10; // BYTE2 state
        end
        2'b10: begin // BYTE2 state
            nextState = 2'b11; // BYTE3 state
        end
        2'b11: begin // BYTE3 state
            nextState = 2'b00; // IDLE state
        end
        default: begin
            nextState = 2'b00; // default to IDLE state
        end
    endcase
end

assign done = doneReg;

endmodule