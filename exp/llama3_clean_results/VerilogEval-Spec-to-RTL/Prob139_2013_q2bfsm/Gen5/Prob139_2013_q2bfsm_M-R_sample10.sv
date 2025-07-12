module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state;
reg [1:0] nextState;
reg [2:0] xSeq;
reg [1:0] yCount;

always @(posedge clk) begin
    if (!resetn) begin
        state <= 2'b00; // STATE_A
        xSeq <= 3'b000;
        yCount <= 2'b00;
        f <= 1'b0;
        g <= 1'b0;
    end else begin
        state <= nextState;
        case (state)
            2'b00: begin // STATE_A
                f <= 1'b0;
                g <= 1'b0;
            end
            2'b01: begin // STATE_B
                f <= 1'b1;
                g <= 1'b0;
            end
            2'b10: begin // STATE_SEQ
                f <= 1'b0;
                if (xSeq == 3'b101) begin
                    g <= 1'b1;
                end else begin
                    g <= 1'b0;
                end
            end
            2'b11: begin // STATE_WAIT_Y
                f <= 1'b0;
                if (y || yCount == 2'b10) begin
                    if (y) begin
                        g <= 1'b1;
                    end else begin
                        g <= 1'b0;
                    end
                end
            end
        endcase
        if (state == 2'b10) begin // STATE_SEQ
            xSeq <= {xSeq[1:0], x};
        end else begin
            xSeq <= 3'b000;
        end
        if (state == 2'b11) begin // STATE_WAIT_Y
            yCount <= yCount + 1'b1;
        end else begin
            yCount <= 2'b00;
        end
    end
end

always @(*) begin
    case (state)
        2'b00: nextState = (resetn)? 2'b01 : 2'b00; // STATE_A to STATE_B
        2'b01: nextState = 2'b10; // STATE_B to STATE_SEQ
        2'b10: nextState = (xSeq == 3'b101)? 2'b11 : 2'b10; // STATE_SEQ to STATE_WAIT_Y
        2'b11: nextState = (y || yCount == 2'b10)? ((y)? 2'b11 : 2'b00) : 2'b11; // STATE_WAIT_Y
    endcase
end

endmodule