module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

// Define an always block that triggers on the positive edge of the clock
always @(posedge clk) begin
    // Update the entire vector q based on d in a single statement
    // This approach simplifies the code and directly describes the intended hardware behavior
    q <= d;
end

endmodule