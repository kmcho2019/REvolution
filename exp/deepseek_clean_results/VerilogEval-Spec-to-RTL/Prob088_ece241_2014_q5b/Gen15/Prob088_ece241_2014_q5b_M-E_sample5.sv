module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // State encoding: 01 = A, 10 = B (one-hot)
    reg [1:0] state;

    // Compact transition LUT:
    // Index = {current_state[1], x}
    // Value = next_state (one-hot)
    wire [1:0] next_state = (state == 2'b01) ? 
                           (x ? 2'b10 : 2'b01) :  // State A transitions
                           (x ? 2'b10 : 2'b10);    // State B transitions

    // Mealy output: z = x in state A, ~x in state B
    assign z = (state == 2'b01) ? x : ~x;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // Reset to state A
        end else begin
            state <= next_state;
        end
    end

endmodule