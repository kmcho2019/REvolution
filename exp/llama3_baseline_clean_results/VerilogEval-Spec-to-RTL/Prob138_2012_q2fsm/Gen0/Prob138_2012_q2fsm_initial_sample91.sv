module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define states
parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101;

// Current state register
reg [2:0] current_state;

// Next state logic
reg [2:0] next_state;

always @(*) begin
    case(current_state)
        A: next_state = w ? B : A;
        B: next_state = w ? C : D;
        C: next_state = w ? E : D;
        D: next_state = w ? F : A;
        E: next_state = w ? E : D;
        F: next_state = w ? C : D;
        default: next_state = A;
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if(reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Output logic
assign z = (current_state == E) || (current_state == F);

endmodule