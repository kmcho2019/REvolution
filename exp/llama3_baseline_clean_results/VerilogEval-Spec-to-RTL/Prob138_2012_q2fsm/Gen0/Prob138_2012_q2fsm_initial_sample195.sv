module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

// Enumerate the states
localparam A = 0;
localparam B = 1;
localparam C = 2;
localparam D = 3;
localparam E = 4;
localparam F = 5;

// Define the current state and next state
reg [2:0] current_state, next_state;

// State table
always @(*) begin
    case (current_state)
        A: next_state = (w) ? B : A;
        B: next_state = (w) ? C : D;
        C: next_state = (w) ? E : D;
        D: next_state = (w) ? F : A;
        E: next_state = (w) ? E : D;
        F: next_state = (w) ? C : D;
        default: next_state = A; // default state
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Output logic
assign z = (current_state == E) || (current_state == F);

endmodule