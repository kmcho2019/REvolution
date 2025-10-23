module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State definitions
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Next state logic (combinational)
    wire next_state = (state == A) ? (in ? A : B) : (in ? B : A);

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        state <= areset ? B : next_state;
    end

    // Output logic (Moore)
    assign out = state;

endmodule