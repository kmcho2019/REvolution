// Define the states as parameters
parameter OFF = 1'b0;
parameter ON  = 1'b1;

module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

reg current_state; // current state

// State register update logic with simplified transitions
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
    end else begin
        case (current_state)
            OFF: current_state <= j ? ON : OFF;
            ON:  current_state <= ~k ? ON : OFF;
        endcase
    end
end

// Direct output from state
assign out = current_state;

// Optional: Clock gating for power reduction (assuming clk_enable is a signal that can be used to enable or disable the clock)
// wire clk_enabled;
// assign clk_enabled = clk & clk_enable;
// always @(posedge clk_enabled or posedge areset) begin
//     if (areset) begin
//         current_state <= OFF;
//     end else begin
//         case (current_state)
//             OFF: current_state <= j ? ON : OFF;
//             ON:  current_state <= ~k ? ON : OFF;
//         endcase
//     end
// end

endmodule