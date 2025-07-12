module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg state;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) 
            state <= 1'b0;
        else 
            state <= (state & x) | (~state & ~x & history);
    end

    // Track last bit for state transitions
    reg history;
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            history <= 1'b0;
        else
            history <= x;
    end

    assign z = state & x;

endmodule