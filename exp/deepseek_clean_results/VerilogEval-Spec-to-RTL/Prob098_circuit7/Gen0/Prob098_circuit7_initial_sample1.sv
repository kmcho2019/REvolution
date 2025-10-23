module TopModule (
    input clk,
    input a,
    output reg q
);

    // Initial state is q=1
    initial begin
        q = 1'b1;
    end

    always @(posedge clk) begin
        // Transition to q=0 when a=1 is detected
        if (a && q) begin
            q <= 1'b0;
        end
    end

endmodule