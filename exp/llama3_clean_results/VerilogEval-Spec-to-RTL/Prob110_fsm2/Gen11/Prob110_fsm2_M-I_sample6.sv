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
reg j_sync, k_sync; // Synchronized inputs

// Synchronize inputs with the clock
always @(posedge clk or posedge areset) begin
    if (areset) begin
        j_sync <= 1'b0;
        k_sync <= 1'b0;
    end else begin
        j_sync <= j;
        k_sync <= k;
    end
end

// Simplified next state logic using synchronized inputs
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
    end else begin
        current_state <= (~current_state & j_sync) | (current_state & ~k_sync);
    end
end

// Output logic directly from state
assign out = current_state;

endmodule