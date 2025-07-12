module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states
localparam B = 1'b1;
localparam A = 1'b0;

reg current_state;
reg next_state;

always @(*) begin
    case(current_state)
        B: next_state = (in) ? B : A;
        A: next_state = (in) ? A : B;
        default: next_state = B; // Default to state B for any other state
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        current_state <= B; // Asynchronous reset to state B
    end else begin
        current_state <= next_state;
    end
end

// Determine output based on current state
always @(*) begin
    case(current_state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b1; // Default output for any other state
    endcase
end

endmodule