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

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // State and output register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
            out <= 1'b0;
        end else begin
            state <= next_state;
            // Output is synchronous with state, Moore output
            out <= (next_state == ON) ? 1'b1 : 1'b0;
        end
    end

endmodule