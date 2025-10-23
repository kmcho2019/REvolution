module TopModule(
    input clk,
    input d,
    output reg q
);

reg clk_enable;  // Clock enable signal active at both positive and negative edges
reg prev_clk;    // Previous clock value

// Combinational logic to detect clock transitions
always @(*) begin
    if (clk!= prev_clk) begin
        clk_enable = 1'b1;
    end else begin
        clk_enable = 1'b0;
    end
end

// Update previous clock value
always @(posedge clk or negedge clk) begin
    prev_clk <= clk;
end

// Single flip-flop with clock enable
always @(posedge clk or negedge clk) begin
    if (clk_enable) begin
        q <= d;
    end
end

endmodule