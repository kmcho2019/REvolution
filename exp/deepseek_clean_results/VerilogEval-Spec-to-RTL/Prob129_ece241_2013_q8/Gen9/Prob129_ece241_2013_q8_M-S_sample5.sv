module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg state;  // Remembers if we've seen '1' followed by '0'

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= 1'b0;
        end else begin
            state <= x ? 1'b1 : (state ? 1'b0 : 1'b0);
        end
    end

    // Mealy output: z=1 when we have state=1 (saw '1' then '0') and current x is '1'
    assign z = state & x;

endmodule