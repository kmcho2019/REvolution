module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state;
reg [1:0] nextState;
reg doneReg;

parameter IDLE = 2'b00;
parameter BYTE1 = 2'b01;
parameter BYTE2 = 2'b10;
parameter BYTE3 = 2'b11;

always @(*) begin
    case(state)
        IDLE: begin
            if (in[3] == 1'b1) begin
                nextState = BYTE1;
            end else begin
                nextState = IDLE;
            end
            doneReg = 1'b0;
        end
        BYTE1: begin
            nextState = BYTE2;
            doneReg = 1'b0;
        end
        BYTE2: begin
            nextState = BYTE3;
            doneReg = 1'b0;
        end
        BYTE3: begin
            nextState = IDLE;
            doneReg = 1'b1;
        end
        default: begin
            nextState = IDLE;
            doneReg = 1'b0;
        end
    endcase
end

always @(posedge clk) begin
    if (reset == 1'b1) begin
        state <= IDLE;
    end else begin
        state <= nextState;
    end
    done <= doneReg;
end

endmodule