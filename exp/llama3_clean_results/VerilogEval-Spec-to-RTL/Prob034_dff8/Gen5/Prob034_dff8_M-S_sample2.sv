module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q = 8'b0 // Explicitly initialize q to avoid unknown states
);

    always @(posedge clk) begin
        q <= d; // Direct assignment eliminates the need for a loop
    end

endmodule