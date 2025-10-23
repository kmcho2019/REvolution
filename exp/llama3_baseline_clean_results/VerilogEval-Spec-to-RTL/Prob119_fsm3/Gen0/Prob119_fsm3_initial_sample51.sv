module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

reg [1:0] state, next_state;

// Define states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Combinational logic for next state and output
always @(*) begin
    case (state)
        A: next_state = (in == 1'b0) ? A : B;
        B: next_state = (in == 1'b0) ? C : B;
        C: next_state = (in == 1'b0) ? A : D;
        D: next_state = (in == 1'b0) ? C : B;
    endcase
    
    // Output logic
    case (state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
    endcase
end

// Sequential logic for state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule