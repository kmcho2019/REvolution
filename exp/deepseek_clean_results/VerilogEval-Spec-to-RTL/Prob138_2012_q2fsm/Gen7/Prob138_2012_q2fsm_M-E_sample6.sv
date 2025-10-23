module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    reg [5:0] state;

    // State transitions (combinational)
    wire [5:0] next_state;
    assign next_state = 
        reset ? 6'b000001 :  // Reset to state A
        (state == 6'b000001) ? (w ? 6'b000010 : 6'b000001) : // A transitions
        (state == 6'b000010) ? (w ? 6'b000100 : 6'b001000) : // B transitions
        (state == 6'b000100) ? (w ? 6'b010000 : 6'b001000) : // C transitions
        (state == 6'b001000) ? (w ? 6'b100000 : 6'b000001) : // D transitions
        (state == 6'b010000) ? (w ? 6'b010000 : 6'b001000) : // E transitions
        (state == 6'b100000) ? (w ? 6'b000100 : 6'b001000) : // F transitions
        6'b000001;  // Default to A

    // State storage (sequential)
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output logic - E or F states produce z=1
    assign z = state[4] | state[5];

endmodule