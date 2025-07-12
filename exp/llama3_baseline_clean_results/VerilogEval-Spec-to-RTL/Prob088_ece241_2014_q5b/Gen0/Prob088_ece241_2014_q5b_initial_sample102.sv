module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // One-hot encoding for states A and B
reg [1:0] next_state;

// One-hot encoding: A = 2'b01, B = 2'b10
localparam A = 2'b01;
localparam B = 2'b10;

always @(*) begin
    case (state)
        A: begin
            if (x == 0) next_state = A;
            else next_state = B;
            z = 0;
        end
        B: begin
            next_state = B; // Regardless of x, stay in B
            if (x == 0) z = 1;
            else z = 0;
        end
        default: begin // If state is neither A nor B (which should not happen)
            next_state = A; // Default to A
            z = 0;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) state <= A; // Asynchronous reset to state A
    else state <= next_state;
end

endmodule