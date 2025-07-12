module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 3-bit state variable
reg [2:0] nextState;

always @(*) begin
    case(state)
        3'b000: // S0
            if (in) begin
                nextState = 3'b001; // S1
            end else begin
                nextState = 3'b000; // Stay in S0
            end
        3'b001: // S1
            if (in) begin
                nextState = 3'b010; // S2
            end else begin
                nextState = 3'b000; // Reset to S0
            end
        3'b010: // S2
            if (in) begin
                nextState = 3'b011; // S3
            end else begin
                nextState = 3'b000; // Reset to S0
            end
        3'b011: // S3
            if (in) begin
                nextState = 3'b100; // S4
            end else begin
                nextState = 3'b000; // Reset to S0
            end
        3'b100: // S4
            if (in) begin
                nextState = 3'b101; // S5
            end else begin
                nextState = 3'b000; // Reset to S0
            end
        3'b101: // S5
            if (in) begin
                nextState = 3'b110; // S6 (flag)
            end else begin
                nextState = 3'b111; // S7 (disc)
            end
        3'b110: // S6 (flag)
            nextState = 3'b000; // Reset to S0
        3'b111: // S7 (disc)
            if (in) begin
                nextState = 3'b111; // Stay in S7 (err)
            end else begin
                nextState = 3'b000; // Reset to S0
            end
        default: nextState = 3'b000; // Reset to S0
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Reset to S0
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        state <= nextState;
        case(state)
            3'b000: begin
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b0;
            end
            3'b001, 3'b010, 3'b011, 3'b100, 3'b101: begin
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b0;
            end
            3'b110: begin
                disc <= 1'b0;
                flag <= 1'b1;
                err <= 1'b0;
            end
            3'b111: begin
                disc <= 1'b1;
                flag <= 1'b0;
                err <= 1'b1;
            end
        endcase
    end
end

endmodule