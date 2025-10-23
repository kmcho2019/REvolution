module TopModule (
    input clk,
    input L,
    input q_in,      // Normal input
    input r_in,      // Load value
    input fb_in1,    // Feedback input 1 (for XOR)
    input fb_in2,    // Feedback input 2
    output reg Q
);

    always @(posedge clk) begin
        if (L) begin
            Q <= r_in;
        end else begin
            Q <= q_in ^ fb_in1 ^ fb_in2;  // Implements the required feedback logic
        end
    end

endmodule