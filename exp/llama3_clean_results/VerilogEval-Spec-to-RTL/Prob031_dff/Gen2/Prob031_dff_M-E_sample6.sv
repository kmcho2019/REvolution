module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_bar; // internal signal for the inverted output

// Create a D flip-flop using basic logic gates
always @(posedge clk) begin
    if (d) begin
        q <= 1;
        q_bar <= 0;
    end else begin
        q <= 0;
        q_bar <= 1;
    end
end

// Alternatively, the above logic can be implemented using a simple assignment
// always @(posedge clk) begin
//     q <= d;
//     q_bar <= ~d;
// end

endmodule