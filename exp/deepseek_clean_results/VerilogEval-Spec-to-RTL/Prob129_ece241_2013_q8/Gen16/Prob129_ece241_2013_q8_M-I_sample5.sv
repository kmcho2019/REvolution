module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg state_1, state_0;  // Separate state bits instead of concatenated register

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state_1 <= 1'b0;
            state_0 <= 1'b0;
        end
        else begin
            state_1 <= state_0;
            state_0 <= x;
        end
    end

    assign z = state_1 & ~state_0 & x;  // Detect 101 pattern: state_1=1, state_0=0, x=1

endmodule