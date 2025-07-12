module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_pos;  // Output of the positive-edge flip-flop
reg q_neg;  // Output of the negative-edge flip-flop
reg prev_clk;  // Store the previous clock value for edge detection

always @(posedge clk or negedge clk) begin
    // Detect the rising edge
    if (clk && !prev_clk) begin
        q_pos <= d;
    end
    // Detect the falling edge
    else if (!clk && prev_clk) begin
        q_neg <= d;
    end
    prev_clk <= clk;  // Update the previous clock value
end

// Select output based on clock edge
assign q = clk? q_pos : q_neg;

endmodule