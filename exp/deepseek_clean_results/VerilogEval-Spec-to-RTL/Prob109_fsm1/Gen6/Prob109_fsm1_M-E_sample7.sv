module TopModule (
    input clk,
    input areset,
    input in,
    output out
);
    reg state;

    // Toggle flip-flop implementation
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1;  // Reset to state B
        end else if (~in) begin  // Toggle only when input is 0
            state <= ~state;
        end
    end

    // Output is directly the state
    assign out = state;
endmodule