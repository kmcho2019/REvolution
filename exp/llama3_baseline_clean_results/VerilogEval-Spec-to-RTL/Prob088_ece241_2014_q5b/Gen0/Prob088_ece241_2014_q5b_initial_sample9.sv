module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] current_state;
reg [1:0] next_state;

// One-hot encoding for states
parameter A = 2'b01;
parameter B = 2'b10;

always @(*) begin
    case (current_state)
        A: next_state = (x) ? B : A;
        B: next_state = (x) ? B : B;
        default: next_state = A; // Default to state A
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case (current_state)
        A: z = (x) ? 1'b1 : 1'b0;
        B: z = (x) ? 1'b0 : 1'b1;
        default: z = 1'b0; // Default output
    endcase
end

endmodule