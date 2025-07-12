module TopModule(
    input           clk,
    input           reset,
    input  [7:0]    in,
    output          done
);

reg [1:0] state; // 0: IDLE, 1: BYTE1, 2: BYTE2, 3: DONE
reg [1:0] nextState;
reg         doneReg;

always @(*) begin
    case(state)
        2'b00: // IDLE
            if (in[3] == 1'b1) begin
                nextState = 2'b01; // BYTE1
            end else begin
                nextState = 2'b00; // IDLE
            end
        2'b01: // BYTE1
            nextState = 2'b10; // BYTE2
        2'b10: // BYTE2
            nextState = 2'b11; // DONE
        2'b11: // DONE
            nextState = 2'b00; // IDLE
    endcase
    doneReg = (state == 2'b11);
end

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE
        done <= 1'b0;
    end else begin
        state <= nextState;
        done <= doneReg;
    end
end

endmodule