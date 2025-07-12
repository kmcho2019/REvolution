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

    // Alternative implementation that might have better timing
    wire z_comb = (history == 2'b10) & x;
    assign z = z_comb;

endmodule