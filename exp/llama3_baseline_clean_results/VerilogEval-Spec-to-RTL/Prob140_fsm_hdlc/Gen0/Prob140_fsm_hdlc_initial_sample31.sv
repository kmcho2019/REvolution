module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state;
reg [2:0] nextState;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case (state)
        0: begin // S0
            if (in) begin
                nextState = 1; // S1
            end else begin
                nextState = 0; // S0
            end
            disc = 0;
            flag = 0;
            err = 0;
        end
        1: begin // S1
            if (in) begin
                nextState = 2; // S2
            end else begin
                nextState = 0; // S0
            end
            disc = 0;
            flag = 0;
            err = 0;
        end
        2: begin // S2
            if (in) begin
                nextState = 3; // S3
            end else begin
                nextState = 0; // S0
            end
            disc = 0;
            flag = 0;
            err = 0;
        end
        3: begin // S3
            if (in) begin
                nextState = 4; // S4
            end else begin
                nextState = 0; // S0
            end
            disc = 0;
            flag = 0;
            err = 0;
        end
        4: begin // S4
            if (in) begin
                nextState = 5; // S5
            end else begin
                nextState = 0; // S0
            end
            disc = 0;
            flag = 0;
            err = 0;
        end
        5: begin // S5
            if (in) begin
                nextState = 6; // S6
            end else begin
                nextState = 0; // S0, discard bit
                disc = 1;
            end
            flag = 0;
            err = 0;
        end
        6: begin // S6
            if (in) begin
                nextState = 7; // S7
            end else begin
                nextState = 0; // S0, flag detected
                flag = 1;
            end
            disc = 0;
            err = 0;
        end
        7: begin // S7
            if (in) begin
                nextState = 7; // S7
            end else begin
                nextState = 0; // S0
            end
            disc = 0;
            flag = 0;
            err = 1;
        end
        default: begin
            nextState = 0; // S0
            disc = 0;
            flag = 0;
            err = 0;
        end
    endcase
end

endmodule