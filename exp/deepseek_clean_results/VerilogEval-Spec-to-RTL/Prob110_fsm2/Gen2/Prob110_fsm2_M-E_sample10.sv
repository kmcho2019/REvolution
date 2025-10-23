module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    // State flip-flop with toggle logic
    reg state;
    
    // Toggle control: j when OFF, k when ON
    wire toggle = (j & ~state) | (k & state);
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;  // Reset to OFF
        end else begin
            state <= state ^ toggle;  // Toggle when control is active
        end
    end

    assign out = state;

endmodule