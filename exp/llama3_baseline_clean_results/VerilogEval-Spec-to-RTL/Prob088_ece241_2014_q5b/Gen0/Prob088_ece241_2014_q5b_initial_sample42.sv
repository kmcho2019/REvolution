module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state;
reg [1:0] next_state;

// One-hot encoding for states
parameter A = 2'b01;
parameter B = 2'b10;

// Output z based on current state and input x
always @(*)
begin
    case (state)
        A: z = ~x;
        B: z = x;
        default: z = 1'b0; // Default output
    endcase
end

// State transitions
always @(*)
begin
    case (state)
        A: 
        begin
            if (~x) next_state = A;
            else next_state = B;
        end
        B: 
        begin
            if (~x) next_state = B;
            else next_state = B;
        end
        default: next_state = A; // Default next state
    endcase
end

// Sequential logic
always @(posedge clk or posedge areset)
begin
    if (areset)
    begin
        state <= A; // Asynchronous reset
    end
    else
    begin
        state <= next_state; // State transition on positive edge of clock
    end
end

endmodule