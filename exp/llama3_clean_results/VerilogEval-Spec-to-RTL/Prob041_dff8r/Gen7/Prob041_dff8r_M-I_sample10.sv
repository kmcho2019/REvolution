// Define a parameterizable DFF module that can handle 8-bit data
module DFF(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

always_ff @(posedge clk) begin
    if (reset) begin
        // Reset the flip-flop to 0 on the positive edge of the clock when reset is high
        q <= 8'b0;
    end else begin
        // Otherwise, load the input 'd' into the flip-flop on the positive edge of the clock
        q <= d;
    end
end

endmodule

// Define the TopModule that instantiates the DFF module
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

// Instantiate the DFF module with its inputs and output connected appropriately
DFF dff(
    .clk(clk),
    .reset(reset),
    .d(d),
    .q(q)
);

endmodule