module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg [1:0] history;  // history[1] = older bit, history[0] = newer bit

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            history <= 2'b00;
        end else begin
            history <= {history[0], x};
        end
    end

    // Mealy output: detects '1' (history[1]), '0' (history[0]), '1' (current x)
    assign z = history[1] & ~history[0] & x;

endmodule