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
parameter DONE = 2'b11;

always @(*) begin
    case(state)
        IDLE: begin
            if (in[3] == 1'b1) begin
                nextState = BYTE1;
            end else begin
                nextState = IDLE;
            end
        end
        BYTE1: begin
            nextState = BYTE2;
        end
        BYTE2: begin
            nextState = DONE;
        end
        DONE: begin
            nextState = IDLE;
        end
        default: nextState = IDLE;
    endcase
end

always @(posedge clk) begin
    if (reset == 1'b1) begin
        state <= IDLE;
        done <= 1'b0;
    end else begin
        state <= nextState;
        if (state == DONE) begin
            done <= 1'b1;
        end else begin
            done <= 1'b0;
        end
    end
end

endmodule