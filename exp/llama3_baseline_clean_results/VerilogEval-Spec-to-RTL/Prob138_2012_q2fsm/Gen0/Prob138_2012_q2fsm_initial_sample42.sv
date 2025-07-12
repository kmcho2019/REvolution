module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define the states of the machine
parameter A = 3'b001,
          B = 3'b010,
          C = 3'b011,
          D = 3'b100,
          E = 3'b101,
          F = 3'b110;

reg [2:0] state;
reg [2:0] next_state;

// Continuous assignment for output z
assign z = (state == E || state == F);

// State flip-flops
always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// State table (next state logic)
always @(*) begin
    case(state)
        A: next_state = w ? B : A;
        B: next_state = w ? C : D;
        C: next_state = w ? E : D;
        D: next_state = w ? F : A;
        E: next_state = w ? E : D;
        F: next_state = w ? C : D;
        default: next_state = A;
    endcase
end

endmodule