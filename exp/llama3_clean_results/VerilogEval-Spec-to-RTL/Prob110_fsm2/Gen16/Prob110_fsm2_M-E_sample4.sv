module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

reg [1:0] current_state; // current state (2 bits to allow for encoding of next state conditions)

// Define the state machine's transition table
localparam OFF = 2'b00;
localparam ON  = 2'b01;

// State register update logic using LUT-based approach
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
    end else begin
        case ({current_state, j, k})
            {OFF, 1'b0, 1'b0}: current_state <= OFF;
            {OFF, 1'b0, 1'b1}: current_state <= OFF;
            {OFF, 1'b1, 1'b0}: current_state <= ON;
            {OFF, 1'b1, 1'b1}: current_state <= ON;
            {ON,  1'b0, 1'b0}: current_state <= ON;
            {ON,  1'b0, 1'b1}: current_state <= OFF;
            {ON,  1'b1, 1'b0}: current_state <= ON;
            {ON,  1'b1, 1'b1}: current_state <= OFF;
            default: current_state <= OFF;
        endcase
    end
end

// Output logic directly from state
assign out = (current_state == ON) ? 1'b1 : 1'b0;

endmodule