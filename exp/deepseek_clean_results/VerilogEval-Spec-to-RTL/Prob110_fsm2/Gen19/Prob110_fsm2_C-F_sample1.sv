module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

// State encoding with meaningful names
localparam OFF = 1'b0;
localparam ON  = 1'b1;

// Combined state transition and output logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        out <= OFF;  // Async reset to OFF state
    end else begin
        // Simplified transition logic:
        // If in ON state, stay unless k=1
        // If in OFF state, transition when j=1
        out <= out ? ~k : j;
    end
end

endmodule