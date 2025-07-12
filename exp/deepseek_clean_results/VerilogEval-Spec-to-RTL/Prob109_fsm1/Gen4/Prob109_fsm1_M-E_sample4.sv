module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // T flip-flop implementation for state storage
    reg state;
    
    // Enable signal for T flip-flop (toggle when state should change)
    wire toggle_en = (state == 1'b0) ? in : ~in;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1;  // Async reset to state B
        end else if (toggle_en) begin
            state <= ~state;  // Toggle state when enabled
        end
    end

    // Output is the state bit directly (Moore machine)
    assign out = state;

endmodule