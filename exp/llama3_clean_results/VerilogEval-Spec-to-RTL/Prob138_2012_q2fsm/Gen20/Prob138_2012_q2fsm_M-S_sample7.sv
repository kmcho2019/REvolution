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

// State table using a case statement for simplicity and readability
always @(*) begin
    case (current_state)
        A: next_state = w? B : A;
        B: next_state = w? C : D;
        C: next_state = w? E : D;
        D: next_state = w? F : A;
        E: next_state = w? E : D;
        F: next_state = w? C : D;
        default: next_state = A; // Default state
    endcase
end

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