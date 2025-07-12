module TopModule (
    input clk,
    input L,
    input q_in,       // Feedback input
    input r_in,       // Load input
    output reg Q      // Output
);

    always @(posedge clk) begin
        if (L) begin
            Q <= r_in;      // Load mode
        end else begin
            Q <= q_in;      // Operation mode (feedback)
        end
    end

endmodule