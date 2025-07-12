module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state;
reg [1:0] next_state;

// One-hot encoded states
parameter A = 2'b01;
parameter B = 2'b10;

always @(*) begin
    case (state)
        A: next_state = (x == 0) ? A : B;
        B: next_state = B;
        default: next_state = A; // default state
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        case (state)
            A: z <= x;
            B: z <= ~x;
            default: z <= 0; // default output
        endcase
        state <= next_state;
    end
end

endmodule