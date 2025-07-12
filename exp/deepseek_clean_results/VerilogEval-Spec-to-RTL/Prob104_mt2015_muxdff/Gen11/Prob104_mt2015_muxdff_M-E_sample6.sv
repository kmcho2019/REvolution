module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    reg feedback_reg;
    wire update_clock = clk & (L | ~L); // Always enabled in this implementation

    always @(posedge update_clock) begin
        if (L) begin
            Q <= r_in;
            feedback_reg <= r_in; // Store loaded value
        end else begin
            Q <= q_in;
            feedback_reg <= q_in; // Store feedback value
        end
    end

endmodule