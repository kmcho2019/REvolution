module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg [1:0] state, next_state;

// Define the states
localparam OFF = 1'b0;
localparam ON  = 1'b1;

always @(*) begin
    case(state)
        OFF: next_state = j ? ON : OFF;
        ON:  next_state = k ? OFF : ON;
        default: next_state = OFF;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= OFF;
    end else begin
        state <= next_state;
        out <= state;
    end
end

endmodule