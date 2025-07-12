module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

// Define states in one-hot encoding
reg [1:0] state;
reg [1:0] next_state;

// One-hot encoding assignments
localparam A = 2'b10;
localparam B = 2'b01;

// Output z based on current state and input x
always_comb begin
    case(state)
        A: z = x;
        B: z = ~x;
        default: z = 1'bx;
    endcase
end

// State transition logic
always_comb begin
    case(state)
        A: next_state = (x) ? B : A;
        B: next_state = B; // B remains in B regardless of x
        default: next_state = A; // Default to A for invalid states
    endcase
end

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule