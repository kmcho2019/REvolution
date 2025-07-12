module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

// State encoding
localparam OFF = 1'b0;
localparam ON  = 1'b1;

reg state, next_state;

// Sequential logic: state update and output update, asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF;
        out <= 1'b0;
    end else begin
        state <= next_state;
        out <= next_state == ON;
    end
end

// Combinational logic to determine next_state
always @(*) begin
    case(state)
        OFF: next_state = j ? ON : OFF;
        ON:  next_state = k ? OFF : ON;
        default: next_state = OFF;
    endcase
end

endmodule