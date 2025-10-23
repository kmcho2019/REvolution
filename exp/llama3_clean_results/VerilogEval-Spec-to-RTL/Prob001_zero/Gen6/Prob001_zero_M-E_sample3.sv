module TopModule (
    output logic zero,
    input  logic clk // Introduced clock input for demonstration purposes
);
always_ff @(posedge clk) begin
    zero <= 1'b0;
end
endmodule