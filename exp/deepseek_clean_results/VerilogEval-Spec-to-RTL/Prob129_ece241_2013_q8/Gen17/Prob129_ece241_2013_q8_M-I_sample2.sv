module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    reg [1:0] x_history;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            x_history <= 2'b00;
            z <= 1'b0;
        end else begin
            // Shift in new value
            x_history <= {x_history[0], x};
            
            // Mealy output: detect 101 pattern (x_history[1] is x_prev_prev, x_history[0] is x_prev)
            z <= x_history[1] & ~x_history[0] & x;
        end
    end

endmodule