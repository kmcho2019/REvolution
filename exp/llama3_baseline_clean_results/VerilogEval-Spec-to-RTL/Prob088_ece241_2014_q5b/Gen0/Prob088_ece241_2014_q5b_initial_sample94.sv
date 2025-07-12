module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

// State encoding
reg [1:0] state;
reg [1:0] next_state;

// One-hot encoding
localparam A = 2'b10;
localparam B = 2'b01;

// Output logic
assign z = (state == A && x == 1'b1) || (state == B);

// Next-state logic
always @(*) begin
    case(state)
        A: next_state = (x == 1'b0) ? A : B;
        B: next_state = B;
        default: next_state = A; // To avoid latch inference
    endcase
end

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule