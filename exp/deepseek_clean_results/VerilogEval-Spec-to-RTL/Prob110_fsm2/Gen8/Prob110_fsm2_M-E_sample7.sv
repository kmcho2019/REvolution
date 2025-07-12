module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

    // Toggle logic: 
    // - When OFF, toggle if j=1
    // - When ON, toggle if k=1
    wire toggle_condition = (out ? k : j);
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            out <= 1'b0;  // Reset to OFF
        end else begin
            out <= out ^ toggle_condition;  // Toggle state when condition met
        end
    end

endmodule