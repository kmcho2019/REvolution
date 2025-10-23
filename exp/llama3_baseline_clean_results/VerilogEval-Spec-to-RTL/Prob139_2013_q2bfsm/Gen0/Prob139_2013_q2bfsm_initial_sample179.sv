module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] currentState; // 0: A, 1: B, 2: C, 3: D, 4: E
reg [1:0] xSeq; // to keep track of x sequence
reg [1:0] yCnt; // to count clock cycles since g was set to 1

always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        currentState <= 0; // state A
        f <= 0;
        g <= 0;
        xSeq <= 0;
        yCnt <= 0;
    end else begin
        case (currentState)
            0: begin // state A
                if (resetn) begin
                    currentState <= 1; // move to state B
                end
                f <= 0;
                g <= 0;
            end
            1: begin // state B
                f <= 1;
                currentState <= 2; // move to state C
            end
            2: begin // state C
                if (xSeq == 2'b101) begin
                    currentState <= 3; // move to state D
                    xSeq <= 0;
                end else begin
                    xSeq <= {x, xSeq[0]};
                end
                f <= 0;
            end
            3: begin // state D
                g <= 1;
                if (y || (yCnt == 2)) begin
                    currentState <= 3; // stay in state D
                    yCnt <= 0;
                end else begin
                    yCnt <= yCnt + 1;
                    if (yCnt == 2) begin
                        currentState <= 4; // move to state E
                    end
                end
            end
            4: begin // state E
                g <= 0;
            end
        endcase
    end
end

endmodule