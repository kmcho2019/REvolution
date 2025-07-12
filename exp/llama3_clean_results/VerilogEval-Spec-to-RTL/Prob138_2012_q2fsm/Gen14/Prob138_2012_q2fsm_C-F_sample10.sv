module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// State codes using one-hot encoding for potential area and power improvements
localparam A = 3'b001;
localparam B = 3'b010;
localparam C = 3'b100;
localparam D = 3'b000; // Using 000 to reduce switching activity in transitions
localparam E = 3'b011;
localparam F = 3'b101;

// Internal state signal
reg [2:0] state;
reg [2:0] next_state;

// State flip-flops with synchronized reset
always @(posedge clk) begin
    if (reset) begin
        state <= A; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// Simplified state table using assign statements
assign next_state = (state == A)? (w? B : A) :
                    (state == B)? (w? C : D) :
                    (state == C)? (w? E : D) :
                    (state == D)? (w? F : A) :
                    (state == E)? (w? E : D) :
                    (state == F)? (w? C : D) :
                    A; // Default state

// Output z using a continuous assignment for efficiency
assign z = (state == E || state == F);

endmodule