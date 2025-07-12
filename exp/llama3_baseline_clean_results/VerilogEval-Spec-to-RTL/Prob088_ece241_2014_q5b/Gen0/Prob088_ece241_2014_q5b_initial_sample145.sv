module TopModule(
    input           clk,
    input           areset,
    input           x,
    output          z
);

// Define the states using one-hot encoding
reg [1:0] state, next_state;
localparam A = 2'b10;
localparam B = 2'b01;

// Asynchronous reset
always @(posedge clk or posedge areset)
begin
    if(areset)
        state <= A;
    else
        state <= next_state;
end

// Next state logic
always @(*)
begin
    case(state)
        A: begin
            if(!x)
                next_state = A;
            else
                next_state = B;
        end
        B: begin
            next_state = B; // Stay in state B regardless of x
        end
        default: next_state = A; // Invalid state, default to A
    endcase
end

// Output logic
assign z = (state == A && x) || (state == B);

endmodule