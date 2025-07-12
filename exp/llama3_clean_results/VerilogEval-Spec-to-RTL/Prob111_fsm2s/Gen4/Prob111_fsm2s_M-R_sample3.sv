module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

// Define states
parameter OFF = 1'b0;
parameter ON  = 1'b1;

// State register
reg state;

// Initialize state
initial state = OFF;

// State machine logic
always @(posedge clk) begin
    if (reset) begin
        state <= OFF;
    end else begin
        case (state)
            OFF: state <= j? ON : OFF;
            ON:  state <= k? OFF : ON;
        endcase
    end
end

// Output logic
assign out = (state == ON)? 1'b1 : 1'b0;

endmodule