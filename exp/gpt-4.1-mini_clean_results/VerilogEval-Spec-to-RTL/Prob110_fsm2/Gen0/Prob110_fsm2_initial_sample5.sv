module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire j,
    input  wire k,
    output reg  out
);

// State encoding
localparam OFF = 1'b0;
localparam ON  = 1'b1;

reg state, next_state;

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= OFF;
    else
        state <= next_state;
end

// Next state logic
always @(*) begin
    case (state)
        OFF: next_state = j ? ON : OFF;
        ON:  next_state = k ? OFF : ON;
        default: next_state = OFF;
    endcase
end

// Output logic (Moore output)
always @(*) begin
    case (state)
        OFF: out = 1'b0;
        ON:  out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule