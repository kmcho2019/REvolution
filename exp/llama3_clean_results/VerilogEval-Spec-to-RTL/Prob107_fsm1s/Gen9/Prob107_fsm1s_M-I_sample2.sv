module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define states using one-hot encoding for potential optimization
localparam STATE_B = 1'b0;
localparam STATE_A = 1'b1;

// State register
reg state;

// Output assignment based on current state
assign out = ~state; // Out is 1 in state B (0) and 0 in state A (1)

// State transition logic simplified
always @(posedge clk) begin
    if(reset) begin
        state <= STATE_B; // Synchronous reset to state B
    end else begin
        case(state)
            STATE_B: state <= in ? STATE_B : STATE_A;
            STATE_A: state <= in ? STATE_A : STATE_B;
            default: state <= STATE_B; // Default to STATE_B for invalid states
        endcase
    end
end

endmodule