// Define a D flip-flop module with an 8-bit input and output
module DFF_8bit(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

always_ff @(posedge clk) begin
    if (reset) begin
        q <= 8'b0;
    end else begin
        q <= d;
    end
end

endmodule

// Instantiate the DFF_8bit module within the TopModule
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

DFF_8bit dff_8bit(
   .clk(clk),
   .reset(reset),
   .d(d),
   .q(q)
);

endmodule