module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Internal registers
reg [1:0] state;
reg [1:0] nextState;
reg outReg;

// Asynchronous reset
always @(posedge clk, posedge areset) begin
    if (areset) begin
        state <= A;
        outReg <= 0;
    end else begin
        state <= nextState;
        outReg <= (state == D)? 1 : 0;
    end
end

// Next state logic
always @(*) begin
    case (state)
        A: nextState = (in)? B : A;
        B: nextState = (in)? B : C;
        C: nextState = (in)? D : A;
        D: nextState = (in)? B : C;
        default: nextState = A;
    endcase
end

// Assign output
assign out = outReg;

endmodule