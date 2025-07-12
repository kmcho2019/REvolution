module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg [1:0] state; // Explicitly define the state register
localparam OFF = 1'b0, ON = 1'b1; // Define the states

always @(posedge clk) begin
    if (reset) begin
        state <= OFF; // Reset to OFF state
    end else begin
        case (state)
            OFF: state <= j ? ON : OFF;
            ON:  state <= k ? OFF : ON;
            default: state <= OFF; // Default to OFF for any other state
        endcase
    end
end

assign out = state; // Assign the output based on the current state

endmodule