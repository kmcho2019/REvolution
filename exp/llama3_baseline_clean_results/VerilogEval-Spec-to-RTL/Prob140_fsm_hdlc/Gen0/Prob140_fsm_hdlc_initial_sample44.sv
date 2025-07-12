module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

// State encoding:
// 0000: Initial state (previous input was 0)
// 0001: 1 consecutive 1
// 0010: 2 consecutive 1s
// 0011: 3 consecutive 1s
// 0100: 4 consecutive 1s
// 0101: 5 consecutive 1s
// 0110: 6 consecutive 1s
// 0111: 7 or more consecutive 1s
// 1000: Discard state (after 5 consecutive 1s)

reg [3:0] state;
reg [3:0] nextState;

always @(posedge clk) begin
    if (reset) begin
        state <= 4'b0000;
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case (state)
        4'b0000: begin
            if (in) begin
                nextState = 4'b0001;
            end else begin
                nextState = 4'b0000;
            end
            disc = 1'b0;
            flag = 1'b0;
            err = 1'b0;
        end
        4'b0001: begin
            if (in) begin
                nextState = 4'b0010;
            end else begin
                nextState = 4'b0000;
            end
            disc = 1'b0;
            flag = 1'b0;
            err = 1'b0;
        end
        4'b0010: begin
            if (in) begin
                nextState = 4'b0011;
            end else begin
                nextState = 4'b0000;
            end
            disc = 1'b0;
            flag = 1'b0;
            err = 1'b0;
        end
        4'b0011: begin
            if (in) begin
                nextState = 4'b0100;
            end else begin
                nextState = 4'b0000;
            end
            disc = 1'b0;
            flag = 1'b0;
            err = 1'b0;
        end
        4'b0100: begin
            if (in) begin
                nextState = 4'b0101;
            end else begin
                nextState = 4'b0000;
            end
            disc = 1'b0;
            flag = 1'b0;
            err = 1'b0;
        end
        4'b0101: begin
            if (in) begin
                nextState = 4'b0110;
            end else begin
                nextState = 4'b1000; // discard
            end
            disc = 1'b0;
            flag = 1'b0;
            err = 1'b0;
        end
        4'b0110: begin
            if (in) begin
                nextState = 4'b0111; // error
            end else begin
                nextState = 4'b0000;
                flag = 1'b1; // flag
            end
            disc = 1'b0;
            err = 1'b0;
        end
        4'b0111: begin
            if (in) begin
                nextState = 4'b0111; // stay in error state
            end else begin
                nextState = 4'b0000;
            end
            disc = 1'b0;
            flag = 1'b0;
            err = 1'b1;
        end
        4'b1000: begin
            nextState = 4'b0000;
            disc = 1'b1; // discard
            flag = 1'b0;
            err = 1'b0;
        end
        default: begin
            nextState = 4'b0000;
            disc = 1'b0;
            flag = 1'b0;
            err = 1'b0;
        end
    endcase
end

endmodule