module TopModule(
    input         clk,
    input         reset,
    input         j,
    input         k,
    output        out
);

// Define states
parameter OFF = 1'b0;
parameter ON  = 1'b1;

reg current_state;
reg next_state;

// Output logic
assign out = current_state;

// State transition logic
always @(*) begin
    case(current_state)
        OFF: next_state = j? ON : OFF;
        ON:  next_state = k? OFF : ON;
        default: next_state = OFF;
    endcase
end

// State register
always @(posedge clk or posedge reset) begin
    if(reset) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

endmodule