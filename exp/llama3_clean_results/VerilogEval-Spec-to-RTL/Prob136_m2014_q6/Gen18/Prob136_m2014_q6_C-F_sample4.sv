module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as parameters using one-hot encoding
parameter A = 3'b001;
parameter B = 3'b010;
parameter C = 3'b011;
parameter D = 3'b100;
parameter E = 3'b101;
parameter F = 3'b110;

// State register
reg [2:0] currentState;
reg [2:0] nextState;

// Gray code state register
reg [2:0] grayState;

// Output z logic
assign z = (currentState == E) || (currentState == F);

// Gray code conversion
always @(*) begin
    case (currentState)
        A: grayState = 3'b001;
        B: grayState = 3'b010;
        C: grayState = 3'b011;
        D: grayState = 3'b100;
        E: grayState = 3'b101;
        F: grayState = 3'b110;
        default: grayState = A;
    endcase
end

// Next state logic
always @(*) begin
    case (currentState)
        A: nextState = w? A : B;
        B: nextState = w? D : C;
        C: nextState = w? D : E;
        D: nextState = w? A : F;
        E: nextState = w? D : E;
        F: nextState = w? D : C;
        default: nextState = A;
    endcase
end

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

endmodule