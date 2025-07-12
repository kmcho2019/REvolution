module TopModule (
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 0 to 7 states
reg [2:0] nextState;

always @(*) begin
    case (state)
        3'b000: // S0
            if (in) begin
                nextState = 3'b001; // S1
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end else begin
                nextState = 3'b000; // Stay in S0
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end
        3'b001: // S1
            if (in) begin
                nextState = 3'b010; // S2
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end else begin
                nextState = 3'b000; // S0
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end
        3'b010: // S2
            if (in) begin
                nextState = 3'b011; // S3
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end else begin
                nextState = 3'b000; // S0
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end
        3'b011: // S3
            if (in) begin
                nextState = 3'b100; // S4
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end else begin
                nextState = 3'b000; // S0
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end
        3'b100: // S4
            if (in) begin
                nextState = 3'b101; // S5
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end else begin
                nextState = 3'b000; // S0
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end
        3'b101: // S5
            if (in) begin
                nextState = 3'b110; // S6
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end else begin
                nextState = 3'b000; // S0
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end
        3'b110: // S6
            if (in) begin
                nextState = 3'b111; // S7
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end else begin
                nextState = 3'b001; // S1, discard
                disc = 1'b1;
                flag = 1'b0;
                err = 1'b0;
            end
        3'b111: // S7
            if (in) begin
                nextState = 3'b111; // Stay in S7
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b1;
            end else begin
                nextState = 3'b000; // S0
                disc = 1'b0;
                flag = 1'b1;
                err = 1'b0;
            end
        default: begin
            nextState = 3'b000; // S0
            disc = 1'b0;
            flag = 1'b0;
            err = 1'b0;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Reset to S0
    end else begin
        state <= nextState;
    end
end

endmodule