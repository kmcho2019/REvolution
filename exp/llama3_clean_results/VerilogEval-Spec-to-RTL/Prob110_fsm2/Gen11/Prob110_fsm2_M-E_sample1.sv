module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

reg [1:0] current_state; // current state
reg [1:0] next_state;    // next state

// State encoding
parameter OFF = 2'b00;
parameter ON  = 2'b01;

// LUT for next state and output
always @(*) begin
    case (current_state)
        OFF: next_state = (j) ? ON : OFF;
        ON:  next_state = (k) ? OFF : ON;
        default: next_state = OFF;
    endcase
end

// State register update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

// Output logic directly from state
assign out = (current_state == ON) ? 1'b1 : 1'b0;

endmodule