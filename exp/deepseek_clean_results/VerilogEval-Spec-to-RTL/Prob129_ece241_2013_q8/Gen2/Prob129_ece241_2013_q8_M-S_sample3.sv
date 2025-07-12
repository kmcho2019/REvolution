module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg [1:0] history;  // Stores previous two bits

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            history <= 2'b00;
        end else begin
            history <= {history[0], x};
        end
    end

    assign z = (history == 2'b10) & x;

endmodule