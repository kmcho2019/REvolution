module right_shifter (
    input clk,
    input d,
    output reg [7:0] q
);

reg [1:0] d_stable;  // Stability detector
wire clk_enable;

// Detect if input is stable for 2 cycles
always @(posedge clk) begin
    d_stable <= {d_stable[0], d};
end

assign clk_enable = (d_stable[1] != d_stable[0]) || (q != {d, q[7:1]});  // Enable clock if input changes or shift needed

always @(posedge clk) begin
    if (clk_enable) begin
        q <= {d, q[7:1]};  // Concatenate new bit with upper 7 bits
    end
end

endmodule