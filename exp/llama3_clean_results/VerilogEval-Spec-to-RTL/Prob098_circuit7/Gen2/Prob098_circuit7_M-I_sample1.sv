module TopModule (
    input clk,
    input a,
    output reg q = 1 // Initialize q to 1 to match the simulation waveform
);

always @(posedge clk) begin
    if (a) begin
        q <= 0; // If a is 1, set q to 0
    end else begin
        // If a is 0, keep q at its current value (which is 1 initially)
    end
end

endmodule