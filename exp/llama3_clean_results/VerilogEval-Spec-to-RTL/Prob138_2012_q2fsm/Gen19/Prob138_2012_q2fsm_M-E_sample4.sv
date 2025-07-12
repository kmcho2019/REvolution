module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// One-hot encoding for states
reg [5:0] state;
reg [5:0] next_state;

// State encoding
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

// State table using multiplexers
always @ (*) begin
    case (state)
        A: next_state = w ? B : A;
        B: next_state = w ? C : D;
        C: next_state = w ? E : D;
        D: next_state = w ? F : A;
        E: next_state = w ? E : D;
        F: next_state = w ? C : D;
        default: next_state = A; // Default to state A
    endcase
end

// Output z
assign z = (state == E) || (state == F);

endmodule