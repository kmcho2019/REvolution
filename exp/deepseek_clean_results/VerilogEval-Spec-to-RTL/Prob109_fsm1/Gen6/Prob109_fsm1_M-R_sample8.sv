module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State definitions
    wire state;
    reg state_reg;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Combinational next state logic
    assign state = (state_reg == A) ? (in ? A : B) : (in ? B : A);

    // Sequential state update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_reg <= B;  // Async reset to state B
        end else begin
            state_reg <= state;
        end
    end

    // Output assignment (Moore machine)
    assign out = state_reg;

endmodule