// Define a parameterizable DFF module that can handle 1-bit data
module DFF1bit(
    input clk,
    input reset,
    input d,
    output logic q
);

always_ff @(posedge clk) begin
    if (reset) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule

// Define the TopModule that instantiates the DFF1bit module for 8 bits
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

// Instantiate the DFF1bit module 8 times using a for loop
genvar i;
for (i = 0; i < 8; i++) begin
    DFF1bit dff1bit(
        .clk(clk),
        .reset(reset),
        .d(d[i]),
        .q(q[i])
    );
end

endmodule