module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Define the states
enum logic [0:0] {OFF, ON} current_state, next_state;

// Output logic
assign out = (current_state == ON) ? 1'b1 : 1'b0;

// Next state logic
always_comb begin
    case(current_state)
        OFF: if(j) next_state = ON;
             else next_state = OFF;
        ON:  if(k) next_state = OFF;
             else next_state = ON;
        default: next_state = OFF;
    endcase
end

// State register
always_ff @(posedge clk) begin
    if(reset) current_state <= OFF;
    else current_state <= next_state;
end

endmodule