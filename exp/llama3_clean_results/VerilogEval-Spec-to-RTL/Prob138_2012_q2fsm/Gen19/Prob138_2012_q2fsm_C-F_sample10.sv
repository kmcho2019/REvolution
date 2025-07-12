module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// State codes using explicit encoding for clarity and maintainability
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

// Internal state signal
reg [2:0] current_state;
reg [2:0] next_state;

// State table using assign statements for simplicity and efficiency
assign next_state = (current_state == A)? (w? B : A) :
                    (current_state == B)? (w? C : D) :
                    (current_state == C)? (w? E : D) :
                    (current_state == D)? (w? F : A) :
                    (current_state == E)? (w? E : D) :
                    (current_state == F)? (w? C : D) :
                    A; // Default state

// State flip-flops with synchronized reset
always @ (posedge clk) begin
    if (reset) begin
        current_state <= A; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

// Output z using a continuous assignment for efficiency
assign z = (current_state == E || current_state == F);

endmodule