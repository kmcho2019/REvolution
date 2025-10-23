module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // One-hot encoding for states A and B
parameter A = 2'b10, B = 2'b01;

// Combinational logic for output 'z' based on current state and input 'x'
assign z = (state == A) ? x : ~x;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to state A
        state <= A;
    end else begin
        case(state)
            A: state <= (x) ? B : A;
            B: state <= B; // Stay in B regardless of 'x'
            default: state <= A; // Reset to A if in an invalid state
        endcase
    end
end

endmodule