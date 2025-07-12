module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 8 states: 0 to 7
reg [2:0] nextState;

always @(*) begin
    case(state)
        3'b000: begin // S0
            if (in) begin
                nextState = 3'b001; // One consecutive 1
            end else begin
                nextState = 3'b000; // No consecutive 1s
            end
        end
        3'b001: begin // S1
            if (in) begin
                nextState = 3'b010; // Two consecutive 1s
            end else begin
                nextState = 3'b000; // No consecutive 1s
            end
        end
        3'b010: begin // S2
            if (in) begin
                nextState = 3'b011; // Three consecutive 1s
            end else begin
                nextState = 3'b000; // No consecutive 1s
            end
        end
        3'b011: begin // S3
            if (in) begin
                nextState = 3'b100; // Four consecutive 1s
            end else begin
                nextState = 3'b000; // No consecutive 1s
            end
        end
        3'b100: begin // S4
            if (in) begin
                nextState = 3'b101; // Five consecutive 1s
            end else begin
                nextState = 3'b000; // No consecutive 1s
            end
        end
        3'b101: begin // S5
            if (in) begin
                nextState = 3'b110; // Six consecutive 1s
            end else begin
                nextState = 3'b000; // No consecutive 1s
            end
        end
        3'b110: begin // S6
            if (in) begin
                nextState = 3'b111; // Seven consecutive 1s (error)
                flag = 1'b1;
            end else begin
                nextState = 3'b000; // No consecutive 1s
                disc = 1'b1;
            end
        end
        3'b111: begin // S7
            if (in) begin
                nextState = 3'b111; // Stay in error state
            end else begin
                nextState = 3'b000; // No consecutive 1s
            end
        end
        default: begin
            nextState = 3'b000;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        state <= nextState;
        if (state == 3'b111) begin
            err <= 1'b1;
        end else begin
            err <= 1'b0;
        end
        if (state == 3'b110 && in == 1'b0) begin
            disc <= 1'b1;
        end else begin
            disc <= 1'b0;
        end
        if (state == 3'b110 && in == 1'b1) begin
            flag <= 1'b1;
        end else begin
            flag <= 1'b0;
        end
    end
end

endmodule