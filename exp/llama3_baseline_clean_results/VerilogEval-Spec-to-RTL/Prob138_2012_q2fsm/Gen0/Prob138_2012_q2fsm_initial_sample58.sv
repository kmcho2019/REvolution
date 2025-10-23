module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// Define state codes for states A to F
parameter A = 5'd0, B = 5'd1, C = 5'd2, D = 5'd3, E = 5'd4, F = 5'd5;

// Current state register
reg [4:0] current_state;

// Next state logic
always @(*)
begin
    case(current_state)
        A: current_state <= (w)? B : A;
        B: current_state <= (w)? C : D;
        C: current_state <= (w)? E : D;
        D: current_state <= (w)? F : A;
        E: current_state <= (w)? E : D;
        F: current_state <= (w)? C : D;
        default: current_state <= A;
    endcase
end

// State flip-flops
always @(posedge clk)
begin
    if(reset)
        current_state <= A;
    else
        current_state <= current_state;
end

// Output logic
assign z = (current_state == E) | (current_state == F);

endmodule