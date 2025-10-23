module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding: A = 0, B = 1
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;
    wire next_state;

    // Simplified combinational logic: next_state = state ^ ~in
    assign next_state = state ^ (~in);

    // Async reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output logic: out = 1 when state is B, else 0
    assign out = (state == B);

endmodule