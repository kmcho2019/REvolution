module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg [1:0] history;  // Stores previous two bits (history[1] is oldest)

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            history <= 2'b00;
        end else begin
            history <= {history[0], x};  // Shift in new bit
        end
    end

    // Mealy output: z=1 when we have '1'(history[1]), '0'(history[0]), and current '1'(x)
    assign z = (history == 2'b10) && x;

endmodule