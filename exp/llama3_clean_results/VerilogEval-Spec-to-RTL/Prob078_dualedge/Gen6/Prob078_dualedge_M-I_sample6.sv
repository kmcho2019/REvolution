module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_pos;  // Output of positive-edge triggered flip-flop
reg q_neg;  // Output of negative-edge triggered flip-flop

// Positive-edge triggered flip-flop
always @(posedge clk) begin
    q_pos <= d;
end

// Negative-edge triggered flip-flop
always @(negedge clk) begin
    q_neg <= d;
end

// Use a continuous assignment to select the output based on the clock edge
assign q = (clk == 1'b1)? q_pos : q_neg;

// Optional: Reset logic for initialization
// This example assumes an active-high reset signal named 'rst'
// always @(posedge rst or negedge clk) begin
//     if (rst) begin
//         q_pos <= 1'b0;
//         q_neg <= 1'b0;
//     end else if (clk) begin
//         q_pos <= d;
//     end else begin
//         q_neg <= d;
//     end
// end

endmodule