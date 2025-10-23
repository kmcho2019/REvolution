module DFF(
    input clk,
    input reset,
    input clk_en, // Clock enable signal
    input [7:0] d,
    output logic [7:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 8'b0;
    end else if (clk_en) begin
        q <= d;
    end
end

endmodule

module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

logic clk_en; // Clock enable signal

// Generate clock enable signal
assign clk_en = 1'b1; // Enable clock always, or use a signal that indicates when the clock should be enabled

DFF dff(
   .clk(clk),
   .reset(reset),
   .clk_en(clk_en),
   .d(d),
   .q(q)
);

endmodule