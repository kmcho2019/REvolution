module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;
    wire next_state;

    // Combinational next state logic with assign and ternary operators
    assign next_state = (state == B) ? (in ? B : A) :
                        (state == A) ? (in ? A : B) : B; // default to B if unknown state

    // Asynchronous reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output depends only on current state
    assign out = state;

endmodule