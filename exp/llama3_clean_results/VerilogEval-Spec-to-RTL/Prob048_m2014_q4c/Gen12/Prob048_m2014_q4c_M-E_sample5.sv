module TopModule(
    input  logic clk,
    input  logic d,
    input  logic r,
    output logic q
);

logic mux_out;

// Multiplexer to select between input data and reset value
always @(posedge clk) begin
    mux_out <= r ? 1'b0 : d; // Select reset value when r is high, otherwise select input data
    q <= mux_out; // Assign multiplexer output to q
end

endmodule