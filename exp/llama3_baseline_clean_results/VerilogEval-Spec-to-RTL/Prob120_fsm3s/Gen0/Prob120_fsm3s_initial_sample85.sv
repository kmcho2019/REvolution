module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define state encoding
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

reg[1:0] state;
reg[1:0] nextState;

// State transition logic
always @(posedge clk) begin
    if(reset) begin
        state <= A;
    end else begin
        state <= nextState;
    end
end

// Next state logic
always @(*) begin
    case(state)
        A: nextState = (in == 0) ? A : B;
        B: nextState = (in == 0) ? C : B;
        C: nextState = (in == 0) ? A : D;
        D: nextState = (in == 0) ? C : B;
        default: nextState = A;
    endcase
end

// Output logic
always @(*) begin
    case(state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0;
    endcase
end

endmodule