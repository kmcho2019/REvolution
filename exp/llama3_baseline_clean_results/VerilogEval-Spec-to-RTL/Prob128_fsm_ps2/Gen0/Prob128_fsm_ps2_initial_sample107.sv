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
    case (state)
        2'b00: begin // IDLE
            if (in[3] == 1) begin
                nextState = 2'b01; // BYTE1
            end else begin
                nextState = 2'b00; // IDLE
            end
            doneReg = 1'b0;
        end
        2'b01: begin // BYTE1
            nextState = 2'b10; // BYTE2
            doneReg = 1'b0;
        end
        2'b10: begin // BYTE2
            nextState = 2'b11; // BYTE3
            doneReg = 1'b0;
        end
        2'b11: begin // BYTE3
            nextState = 2'b00; // IDLE
            doneReg = 1'b1;
        end
        default: begin
            nextState = 2'b00; // IDLE
            doneReg = 1'b0;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        done <= 1'b0;
    end else begin
        state <= nextState;
        done <= doneReg;
    end
end

endmodule