module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

always_ff @(posedge clk) begin
    if (reset) begin
        q <= 8'b0; // Set q to 0 when reset is high
    end else begin
        q <= d; // Assign input d to output q when reset is low
    end
end

endmodule