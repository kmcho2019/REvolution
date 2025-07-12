module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define states using binary encoding
localparam STATE_B = 1'b0;
localparam STATE_A = 1'b1;

reg state; // State variable

always @(posedge clk) begin
    if(reset) begin
        state <= STATE_B; // Reset to state B
    end else begin
        case(state)
            STATE_B: state <= in? STATE_B : STATE_A;
            STATE_A: state <= in? STATE_A : STATE_B;
            default: state <= STATE_B; // Default state
        endcase
    end
end

assign out = ~state; // Output directly related to the state

endmodule