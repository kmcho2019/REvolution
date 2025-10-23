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

    // Next state combinational logic
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
            out <= next_state; // output follows registered next_state, Moore output
        end
    end

endmodule