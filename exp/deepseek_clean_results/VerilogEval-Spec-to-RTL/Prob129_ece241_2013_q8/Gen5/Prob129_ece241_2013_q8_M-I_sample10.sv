module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    reg [1:0] history;  // Stores previous two bits (history[1] is oldest)
    wire pattern_detected;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            history <= 2'b00;
            z <= 1'b0;
        end else begin
            history <= {history[0], x};  // Shift in new bit
            // Clock gating: only update z when x is 1 (when pattern could complete)
            if (x) begin
                z <= (history == 2'b10);
            end else begin
                z <= 1'b0;
            end
        end
    end

endmodule