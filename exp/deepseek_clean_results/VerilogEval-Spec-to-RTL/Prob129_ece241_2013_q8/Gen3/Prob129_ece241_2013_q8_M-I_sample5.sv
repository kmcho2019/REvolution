module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    reg [1:0] history;  // Stores previous two bits
    reg x_prev;         // For detecting input changes
    wire clk_en;        // Clock enable signal

    // Clock gating when input changes
    assign clk_en = (x != x_prev) | ~aresetn;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            history <= 2'b00;
            x_prev <= 1'b0;
            z <= 1'b0;
        end else if (clk_en) begin
            history <= {history[0], x};
            x_prev <= x;
            // Registered output for better timing
            z <= (history == 2'b10) & x;
        end
    end

endmodule