module TopModule (
    input  clk,    // Clock input
    input  d,      // Data input
    input  r,      // Synchronous reset (active high)
    output q       // Output
);

reg stored_data;
reg last_d;
wire data_changed = (d != last_d);
wire clock_enable = data_changed || r;

always @(posedge clk) begin
    last_d <= d;
    if (clock_enable) begin
        stored_data <= r ? 1'b0 : d;
    end
end

assign q = stored_data;

endmodule