module TopModule (
    input clk,
    input L,
    input q_in,    // Current state of this bit
    input r_in,    // Load value
    input fb_in,   // Feedback input (different for each position)
    output reg Q
);

    always @(posedge clk) begin
        Q <= L ? r_in : fb_in;
    end

endmodule