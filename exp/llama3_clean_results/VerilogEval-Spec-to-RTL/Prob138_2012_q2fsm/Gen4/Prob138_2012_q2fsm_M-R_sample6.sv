module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [5:0] state;
reg [5:0] next_state;

// One-hot encoding for states
localparam A = 6'b000001;
localparam B = 6'b000010;
localparam C = 6'b000100;
localparam D = 6'b001000;
localparam E = 6'b010000;
localparam F = 6'b100000;

// State flip-flops and next state logic
always @ (posedge clk) begin
    if (reset) begin
        state <= A; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// Next state logic using assign statements
assign next_state = 
    (state == A && w) ? B :
    (state == A && !w) ? A :
    (state == B && w) ? C :
    (state == B && !w) ? D :
    (state == C && w) ? E :
    (state == C && !w) ? D :
    (state == D && w) ? F :
    (state == D && !w) ? A :
    (state == E && w) ? E :
    (state == E && !w) ? D :
    (state == F && w) ? C :
    (state == F && !w) ? D :
    A; // Default to state A

// Output z logic using assign statement
assign z = (state == E) || (state == F);

endmodule