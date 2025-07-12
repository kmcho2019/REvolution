module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

    // Two-bit state encoding
    localparam [1:0] OFF = 2'b00;
    localparam [1:0] ON  = 2'b01;

    reg [1:0] state, next_state;

    // Next state logic combinational block
    always @* begin
        case (state)
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
            // Moore output depends on current state after update
            out <= (next_state == ON);
        end
    end

endmodule