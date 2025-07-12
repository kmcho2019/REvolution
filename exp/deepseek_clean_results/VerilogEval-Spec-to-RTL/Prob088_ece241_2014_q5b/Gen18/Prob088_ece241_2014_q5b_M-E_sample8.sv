module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg [1:0] state;

    // Shift-based transition logic
    wire [1:0] next_state = state[1] ? {~x, x} : state;

    // Optimized XOR output logic
    assign z = (state[1] & x) | (state[0] & ~x);

    // State transition with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b10;  // Reset to state A
        end
        else begin
            state <= next_state;
        end
    end

endmodule