module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg [1:0] history;  // Stores previous two bits (history[1] is older)

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            history <= 2'b0;
        else
            history <= {history[0], x};  // Shift register update
    end

    // Mealy output: detect '1' (history[1]), '0' (history[0]), '1' (current x)
    assign z = (history == 2'b10) & x;

endmodule