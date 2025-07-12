module TopModule(
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

// Define the states
parameter S0 = 1'b0, S1 = 1'b1;

reg [0:0] current_state, next_state;

// Make state observable
assign state = current_state;

// Combinational logic for q
assign q = (current_state == S1 && a == 1'b1) || (b == 1'b1 && a == 1'b0);

// Sequential logic
always @(posedge clk) begin
    case (current_state)
        S0: if (a == 1'b0 && b == 1'b1) next_state = S1;
             else if (a == 1'b1 && b == 1'b1) next_state = S0;
             else next_state = S0;
        S1: if (a == 1'b0 && b == 1'b0) next_state = S0;
             else next_state = S1;
        default: next_state = S0;
    endcase
    
    current_state <= next_state;
end

initial begin
    current_state = S0;
end

endmodule