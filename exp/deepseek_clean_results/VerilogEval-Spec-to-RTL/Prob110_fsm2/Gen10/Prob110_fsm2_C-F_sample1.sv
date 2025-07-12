module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);
    wire next_state;
    
    // Combinational next state logic
    assign next_state = (out & ~k) | (~out & j);
    
    // Sequential state register with direct output
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            out <= 1'b0;  // Reset to OFF state
        end else begin
            out <= next_state;
        end
    end
endmodule