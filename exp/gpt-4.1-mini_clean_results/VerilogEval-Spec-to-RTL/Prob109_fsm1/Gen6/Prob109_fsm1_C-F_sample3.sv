module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    // State encoding: A = 0, B = 1
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;
    reg next_state;

    // Combinational next state logic
    always @(*) begin
        case (state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B;  // Safe default
        endcase
    end

    // Sequential logic: asynchronous reset and synchronous state & output update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;
            out   <= B;   // Output reflects reset state (Moore output)
        end else begin
            state <= next_state;
            out   <= next_state; // Output updates in sync with state to reflect Moore output
        end
    end

endmodule