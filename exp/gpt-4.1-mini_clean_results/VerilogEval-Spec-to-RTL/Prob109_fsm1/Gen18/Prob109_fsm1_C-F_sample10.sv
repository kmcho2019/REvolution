module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    // Combinational next-state logic
    always @(*) begin
        case (state)
            B: next_state = in ? B : A;
            A: next_state = in ? A : B;
            default: next_state = B; // safe default
        endcase
    end

    // State register with asynchronous reset to state B
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore machine output (continuous assignment)
    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule