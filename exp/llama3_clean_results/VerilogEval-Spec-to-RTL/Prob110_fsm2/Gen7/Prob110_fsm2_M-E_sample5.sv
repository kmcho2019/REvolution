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

// State machine logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
    end else begin
        case ({current_state, j, k})
            3'b000: current_state <= OFF;
            3'b001: current_state <= OFF;
            3'b010: current_state <= ON;
            3'b011: current_state <= ON;
            3'b100: current_state <= ON;
            3'b101: current_state <= OFF;
            3'b110: current_state <= ON;
            3'b111: current_state <= OFF;
        endcase
    end
end

endmodule