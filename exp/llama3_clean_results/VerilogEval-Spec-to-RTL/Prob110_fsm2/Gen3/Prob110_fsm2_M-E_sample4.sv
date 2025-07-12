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

// Lookup table for next state and output
reg [1:0] next_state_lut;
always @(*) begin
    case ({current_state, j, k})
        3'b000: next_state_lut = {1'b0, 1'b0}; // OFF, j=0, k=0
        3'b001: next_state_lut = {1'b0, 1'b0}; // OFF, j=0, k=1
        3'b010: next_state_lut = {1'b1, 1'b1}; // OFF, j=1, k=0
        3'b011: next_state_lut = {1'b1, 1'b1}; // OFF, j=1, k=1
        3'b100: next_state_lut = {1'b1, 1'b1}; // ON, j=0, k=0
        3'b101: next_state_lut = {1'b1, 1'b1}; // ON, j=0, k=1
        3'b110: next_state_lut = {1'b0, 1'b0}; // ON, j=1, k=0
        3'b111: next_state_lut = {1'b0, 1'b0}; // ON, j=1, k=1
        default: next_state_lut = {1'b0, 1'b0};
    endcase
end

// State machine logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state_lut[0];
    end
end

endmodule