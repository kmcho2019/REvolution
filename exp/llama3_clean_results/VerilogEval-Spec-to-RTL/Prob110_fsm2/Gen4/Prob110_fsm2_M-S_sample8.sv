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
assign out = state;

// State register with asynchronous reset and transition logic
always_ff @(posedge clk or posedge areset) begin
    if(areset) state <= OFF;
    else begin
        case(state)
            OFF: state <= j ? ON : OFF;
            ON:  state <= k ? OFF : ON;
        endcase
    end
end

endmodule