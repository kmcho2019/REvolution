module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // State counter (0-5 corresponds to A-F)
    reg [2:0] state_counter;

    // Next state logic
    wire [2:0] next_state;
    assign next_state = 
        (reset) ? 3'd0 :  // Reset to state A (0)
        (state_counter == 3'd0) ? (w ? 3'd1 : 3'd0) :  // A transitions
        (state_counter == 3'd1) ? (w ? 3'd2 : 3'd3) :    // B transitions
        (state_counter == 3'd2) ? (w ? 3'd4 : 3'd3) :   // C transitions
        (state_counter == 3'd3) ? (w ? 3'd5 : 3'd0) :   // D transitions
        (state_counter == 3'd4) ? (w ? 3'd4 : 3'd3) :   // E transitions
        (state_counter == 3'd5) ? (w ? 3'd2 : 3'd3) :   // F transitions
        3'd0;  // Default (should never occur)

    // State storage
    always @(posedge clk) begin
        state_counter <= next_state;
    end

    // Output logic - active when counter >= 4 (states E and F)
    assign z = (state_counter >= 3'd4);

endmodule