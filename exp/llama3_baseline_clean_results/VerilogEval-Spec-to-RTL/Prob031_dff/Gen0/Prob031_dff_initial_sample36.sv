module TopModule(
    input       clk, // Clock
    input       d,   // Data to be stored
    output reg  q_out // Stored value output
);

always @(posedge clk) begin
    q_out <= d;
end

endmodule