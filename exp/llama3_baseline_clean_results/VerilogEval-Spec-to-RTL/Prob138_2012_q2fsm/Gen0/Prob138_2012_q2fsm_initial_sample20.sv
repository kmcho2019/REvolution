module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] state; // Encoding for states A to F
reg [2:0] next_state;

// State encoding
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

// Next state logic
always @(*) begin
    case(state)
        A: next_state = w ? B : A;
        B: next_state = w ? C : D;
        C: next_state = w ? E : D;
        D: next_state = w ? F : A;
        E: next_state = w ? E : D;
        F: next_state = w ? C : D;
        default: next_state = A; // Default to A on unknown state
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if(reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Output logic
always @(*) begin
    case(state)
        E, F: z = 1;
        default: z = 0;
    endcase
end

endmodule