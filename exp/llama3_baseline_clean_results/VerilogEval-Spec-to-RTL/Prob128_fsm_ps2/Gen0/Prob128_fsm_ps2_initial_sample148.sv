module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state;
reg [1:0] nextState;
reg doneReg;

always @(*) begin
    case(state)
        2'b00: begin // IDLE
            if (in[3] == 1'b1) begin
                nextState = 2'b01; // BYTE1
            end else begin
                nextState = 2'b00; // Stay in IDLE
            end
        end
        2'b01: begin // BYTE1
            nextState = 2'b10; // BYTE2
        end
        2'b10: begin // BYTE2
            nextState = 2'b11; // DONE
        end
        2'b11: begin // DONE
            nextState = 2'b00; // Go back to IDLE
        end
        default: nextState = 2'b00; // Default to IDLE
    endcase
    doneReg = (state == 2'b11)? 1'b1 : 1'b0;
end

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        doneReg <= 1'b0;
    end else begin
        state <= nextState;
        doneReg <= doneReg;
    end
end

assign done = doneReg;

endmodule