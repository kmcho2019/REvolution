module TopModule(
    input           clk,
    input           reset,
    input  [7:0]    in,
    output          done
);

reg [1:0] state; // 0: IDLE, 1: BYTE1, 2: BYTE2
reg [1:0] nextState;

always @(*) begin
    case (state)
        2'b00: // IDLE
            if (in[3]) begin
                nextState = 2'b01; // transition to BYTE1
            end else begin
                nextState = 2'b00; // stay in IDLE
            end
        2'b01: // BYTE1
            nextState = 2'b10; // transition to BYTE2
        2'b10: // BYTE2
            nextState = 2'b00; // transition back to IDLE
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // reset to IDLE state
        done <= 1'b0; // reset done signal
    end else begin
        state <= nextState;
        if (state == 2'b10) begin // in BYTE2 state
            done <= 1'b1; // set done signal
        end else begin
            done <= 1'b0; // clear done signal
        end
    end
end

endmodule