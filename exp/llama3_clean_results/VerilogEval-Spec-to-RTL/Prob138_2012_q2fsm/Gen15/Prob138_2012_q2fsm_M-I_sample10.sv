module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [5:0] state;
reg [5:0] next_state;

// State encoding (one-hot)
localparam A = 6'b000001;
localparam B = 6'b000010;
localparam C = 6'b000100;
localparam D = 6'b001000;
localparam E = 6'b010000;
localparam F = 6'b100000;

// State flip-flops
always @ (posedge clk) begin
    if (reset) begin
        state <= A; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// State table using case statement
always @ (*) begin
    case (state)
        A: next_state = w? B : A;
        B: next_state = w? C : D;
        C: next_state = w? E : D;
        D: next_state = w? F : A;
        E: next_state = w? E : D;
        F: next_state = w? C : D;
        default: next_state = A;
    endcase
end

// Output z
assign z = (state == E) || (state == F); // z is high when state is E or F

endmodule