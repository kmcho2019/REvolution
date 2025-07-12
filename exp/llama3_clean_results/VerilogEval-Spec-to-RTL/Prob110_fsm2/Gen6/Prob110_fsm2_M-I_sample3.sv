module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

// Define states
parameter OFF = 1'b0;
parameter ON  = 1'b1;

// Current state register
reg current_state;

// Initialize output
assign out = current_state;

// Synchronize inputs with the clock to avoid potential metastability issues
reg j_sync, k_sync;
always @(posedge clk) begin
    j_sync <= j;
    k_sync <= k;
end

// State machine logic with synchronized inputs
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
    end else begin
        case (current_state)
            OFF: current_state <= j_sync ? ON : OFF;
            ON:  current_state <= k_sync ? OFF : ON;
        endcase
    end
end

endmodule