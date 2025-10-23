module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] state;
reg [2:0] next_state;

// State encoding
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

// State flip-flops
always @ (posedge clk) begin
    if (reset) begin
        state <= A; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// State table using assign statements
assign next_state = (state == A)? (w? B : A) :
                    (state == B)? (w? C : D) :
                    (state == C)? (w? E : D) :
                    (state == D)? (w? F : A) :
                    (state == E)? (w? E : D) :
                    (state == F)? (w? C : D) :
                    A; // Default to state A

// Output z
assign z = state[2]; // z is high when state is E or F

endmodule