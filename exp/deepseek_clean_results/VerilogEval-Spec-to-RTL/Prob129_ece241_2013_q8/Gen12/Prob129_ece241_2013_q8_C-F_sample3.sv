module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg [1:0] history;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            history <= 2'b00;
        end else begin
            history <= {history[0], x};
        end
    end

    // Optimal output logic using bit-wise operations
    assign z = history[1] & ~history[0] & x;

endmodule