module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    wire gated_clk = clk & L;

    always @(posedge gated_clk or negedge L) begin
        if (!L) begin
            // Hold state - clock is gated
            Q <= q_in;  // Feedback path comes from parent module
        end else begin
            // Active load
            Q <= r_in;
        end
    end

endmodule