module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    // State encoding with two bits (for clarity and extension)
    localparam [1:0] OFF = 2'b00;
    localparam [1:0] ON  = 2'b01;

    reg [1:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        case(state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // Sequential state update and output assignment with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
            out <= 1'b0;
        end else begin
            state <= next_state;
            // Output depends only on the current state (Moore)
            out <= (next_state == ON) ? 1'b1 : 1'b0;
        end
    end

endmodule