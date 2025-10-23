module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding for readability
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;

    // Minimal next-state logic using XOR-based expression
    wire next_state = state ^ ~in;

    // State register with asynchronous reset to B
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore machine output directly assigned from state
    assign out = state;

endmodule