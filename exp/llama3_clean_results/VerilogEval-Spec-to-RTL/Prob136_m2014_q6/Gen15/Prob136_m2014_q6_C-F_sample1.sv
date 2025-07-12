module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states using a hybrid approach for efficiency
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b011;
parameter D = 3'b010;
parameter E = 3'b110;
parameter F = 3'b111;

// State register
reg [2:0] state;
reg [2:0] next_state;

// Combinational logic for next state, simplified for performance
always @(*) begin
    case (state)
        A: next_state = w ? A : B;
        B: next_state = w ? D : C;
        C: next_state = w ? D : E;
        D: next_state = w ? A : F;
        E: next_state = w ? D : E;
        F: next_state = w ? D : C;
        default: next_state = A;
    endcase
end

// Combinational logic for output z, direct assignment for area efficiency
assign z = (state == E || state == F) ? 1 : 0;

// Update the state on the positive edge of the clock, with reset consideration
always @(posedge clk) begin
    if (reset) state <= A;
    else state <= next_state;
end

endmodule