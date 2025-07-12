module TopModule(
    input        clk,
    input        areset,
    input        in,
    output       out
);

// Define the states
localparam STATE_A = 1'b0;
localparam STATE_B = 1'b1;

// Current state register
reg state;

// Lookup table for next state based on current state and input
always @(*) begin
    case({state, in})
        {STATE_A, 1'b0}: state <= STATE_B; // A --0--> B
        {STATE_A, 1'b1}: state <= STATE_A; // A --1--> A
        {STATE_B, 1'b0}: state <= STATE_A; // B --0--> A
        {STATE_B, 1'b1}: state <= STATE_B; // B --1--> B
        default: state <= STATE_B; // Default to state B
    endcase
end

// Sequential process to update the current state
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= STATE_B; // asynchronously reset into state B
    end else begin
        // No need for additional logic here; the combinational block updates state
    end
end

// Assign output based on the current state
assign out = state;

endmodule