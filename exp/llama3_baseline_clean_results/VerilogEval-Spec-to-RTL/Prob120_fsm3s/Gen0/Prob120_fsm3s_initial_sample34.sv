module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// State register
reg [1:0] currentState, nextState;

// Output logic
always @(currentState) begin
    case(currentState)
        A: out = 1'b0;
        B: out = 1'b0;
        C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0; // default output
    endcase
end

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        currentState <= A; // reset to state A
    end else begin
        case(currentState)
            A: begin
                if (~in) begin
                    nextState <= A;
                end else begin
                    nextState <= B;
                end
            end
            B: begin
                if (~in) begin
                    nextState <= C;
                end else begin
                    nextState <= B;
                end
            end
            C: begin
                if (~in) begin
                    nextState <= A;
                end else begin
                    nextState <= D;
                end
            end
            D: begin
                if (~in) begin
                    nextState <= C;
                end else begin
                    nextState <= B;
                end
            end
            default: nextState <= A; // default next state
        endcase
        currentState <= nextState;
    end
end

endmodule