module TopModule (
    input clk,
    input in,
    output reg out = 0  // Initialize for simulation only
);

    always @(posedge clk) begin
        out <= out ^ in;
    end

endmodule