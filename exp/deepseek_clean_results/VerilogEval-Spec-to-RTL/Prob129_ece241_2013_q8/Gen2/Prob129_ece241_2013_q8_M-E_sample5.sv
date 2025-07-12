module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg [1:0] history;

    // Shift register to track input history
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            history <= 2'b00;
        end else begin
            history <= {history[0], x};
        end
    end

    // Mealy output: detect '1' after '01' in history
    assign z = (history == 2'b01) && x;

endmodule