module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output z
);

    // Stores previous two bits (history[1] is older, history[0] is newer)
    reg [1:0] history;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            history <= 2'b00;
        end else begin
            history <= {history[0], x};  // Shift register update
        end
    end

    // Mealy output: detect pattern "10" in history and current '1'
    assign z = (history == 2'b10) && x;

endmodule