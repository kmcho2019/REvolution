module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define states
parameter A = 0;
parameter B = 1;
parameter C = 2;
parameter D = 3;
parameter E = 4;
parameter F = 5;

// Current state
reg [2:0] state;

// Next state
reg [2:0] next_state;

// Always block for state flip-flops
always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Always block for state table
always @(*) begin
    case (state)
        A: next_state = w ? B : A;
        B: next_state = w ? C : D;
        C: next_state = w ? E : D;
        D: next_state = w ? F : A;
        E: next_state = w ? E : D;
        F: next_state = w ? C : D;
        default: next_state = A;
    endcase
end

// Output z based on the current state
assign z = (state == E || state == F);

endmodule