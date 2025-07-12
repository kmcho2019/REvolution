module TopModule (
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

// Combined sequential and next-state logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF;
        out   <= 1'b0;
    end else begin
        // Next-state logic via case statement
        case (state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
        state <= next_state;
        out   <= (next_state == ON);  // Moore output registered
    end
end

endmodule