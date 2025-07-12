module TopModule (
    input             clk,
    input      [7:0]  in,
    output reg [7:0]  pedge
);

    // Store the inverse of the previous input bit
    reg [7:0] inv_prev_in;

    always @(posedge clk) begin
        // Detect positive edge: previous bit was 0 => inv_prev_in is 1,
        // current bit is 1 => AND is 1
        pedge      <= inv_prev_in & in;
        // Update inv_prev_in with inverse of current input
        inv_prev_in <= ~in;
    end

endmodule