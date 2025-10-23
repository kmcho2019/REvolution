module TopModule (
    input           clk,       // Clock signal
    input           ar,       // Asynchronous reset
    input           d,        // Input data
    output reg      q         // Output data
);

always @(posedge clk or posedge ar) begin
    if (ar) begin
        // Asynchronous reset condition
        q <= 1'b0;
    end else if (posedge clk) begin
        // On positive edge of clock, assign input data to output
        q <= d;
    end
end

endmodule