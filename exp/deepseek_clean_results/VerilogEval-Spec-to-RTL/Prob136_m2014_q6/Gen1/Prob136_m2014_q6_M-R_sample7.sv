module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

// State encoding (binary)
parameter [2:0] A = 3'b000,
                B = 3'b001,
                C = 3'b010,
                D = 3'b011,
                E = 3'b100,
                F = 3'b101;

reg [2:0] current_state;

// Next state logic using continuous assignments
wire [2:0] next_state = 
    (current_state == A) ? (w ? A : B) :
    (current_state == B) ? (w ? D : C) :
    (current_state == C) ? (w ? D : E) :
    (current_state == D) ? (w ? A : F) :
    (current_state == E) ? (w ? D : E) :
    (current_state == F) ? (w ? D : C) :
    A;  // default case

// State register
always @(posedge clk) begin
    if (reset)
        current_state <= A;
    else
        current_state <= next_state;
end

// Output logic
assign z = (current_state == E) | (current_state == F);

endmodule