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
        state <= 2'b00; // Idle state
        doneReg <= 1'b0;
    end else begin
        state <= nextState;
        doneReg <= (state == 2'b11) ? 1'b1 : 1'b0;
    end
end

always @(*) begin
    case (state)
        2'b00: begin // Idle state
            if (in[3] == 1'b1) begin
                nextState = 2'b01; // Byte1 state
            end else begin
                nextState = 2'b00; // Stay in Idle state
            end
        end
        2'b01: begin // Byte1 state
            nextState = 2'b10; // Byte2 state
        end
        2'b10: begin // Byte2 state
            nextState = 2'b11; // Byte3 state
        end
        2'b11: begin // Byte3 state
            nextState = 2'b00; // Idle state
        end
    endcase
end

assign done = doneReg;

endmodule