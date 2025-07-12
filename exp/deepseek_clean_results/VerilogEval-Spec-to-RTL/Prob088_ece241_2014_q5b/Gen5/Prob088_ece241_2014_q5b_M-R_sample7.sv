module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    wire state_B;
    reg state_B_ff;

    // Combinational state logic with feedback
    assign state_B = areset ? 1'b0 : (state_B_ff | (~state_B_ff & x));

    // Output logic remains the same
    assign z = ~state_B ? x : ~x;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_B_ff <= 1'b0;
        end
        else begin
            state_B_ff <= state_B;
        end
    end

endmodule