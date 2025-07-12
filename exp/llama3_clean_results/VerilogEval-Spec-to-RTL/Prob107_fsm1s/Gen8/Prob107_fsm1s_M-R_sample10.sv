module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define states
localparam STATE_B = 1'b0;
localparam STATE_A = 1'b1;

// State register
reg state;

// Output assignment based on current state
assign out = ~state; // Out is 1 in state B (0) and 0 in state A (1)

// State transition logic
always @(posedge clk) begin
    if(reset) begin
        // Synchronous reset to state B
        state <= STATE_B;
    end else begin
        // State transitions based on current state and input
        case(state)
            STATE_B: state <= in ? STATE_B : STATE_A;
            STATE_A: state <= in ? STATE_A : STATE_B;
            default: state <= STATE_B; // Default to STATE_B for invalid states
        endcase
    end
end

endmodule