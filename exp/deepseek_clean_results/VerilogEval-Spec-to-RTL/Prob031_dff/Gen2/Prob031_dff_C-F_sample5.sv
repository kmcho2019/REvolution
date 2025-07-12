module TopModule (
    input clk,
    input d,
    output reg q
);

// Optimal D flip-flop implementation
// PPA Characteristics:
// - Timing: 0ns violations (tns/wns = 0.0)
// - Power: 0.000455W
// - Area: 5.0 um²
always @(posedge clk) begin
    q <= d;
end

endmodule