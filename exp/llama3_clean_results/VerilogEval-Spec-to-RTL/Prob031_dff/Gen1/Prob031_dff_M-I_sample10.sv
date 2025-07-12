module TopModule(
    input clk,
    input d,
    output reg q
);

// Attribute to suggest synthesis tool to use a power-efficient flip-flop
(* keep = "true", power_critical = "true" *)
always_ff @(posedge clk) begin
    q <= d;
end

endmodule