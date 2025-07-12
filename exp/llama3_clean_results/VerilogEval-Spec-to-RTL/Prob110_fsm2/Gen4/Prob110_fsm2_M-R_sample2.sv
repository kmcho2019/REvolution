module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

// Define states
enum logic [0:0] {OFF, ON} state;

// Output logic
assign out = (state == ON)? 1'b1 : 1'b0;

// State transition logic using assign
logic next_state;
assign next_state = (state == OFF && j) ? ON :
                    (state == ON && k) ? OFF :
                    state;

// State register with asynchronous reset
always_ff @(posedge clk or posedge areset) begin
    if(areset) state <= OFF;
    else state <= next_state;
end

endmodule