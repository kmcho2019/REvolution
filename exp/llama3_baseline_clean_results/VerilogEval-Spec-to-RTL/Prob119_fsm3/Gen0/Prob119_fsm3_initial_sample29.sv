module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Current state and next state variables
reg [1:0] current_state;
reg [1:0] next_state;

// Output logic
always @(current_state) begin
    case (current_state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
    endcase
end

// Next state logic
always @(current_state, in) begin
    case (current_state)
        A: next_state = in? B : A;
        B: next_state = in? B : C;
        C: next_state = in? D : A;
        D: next_state = in? B : C;
    endcase
end

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule