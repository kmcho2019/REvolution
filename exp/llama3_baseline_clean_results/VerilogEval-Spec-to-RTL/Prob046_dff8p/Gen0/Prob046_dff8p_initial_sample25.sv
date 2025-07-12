module TopModule(
    input  clk,
    input  reset,
    input  [7:0] d,
    output [7:0] q
);

parameter RESET_VALUE = 8'h34; // Reset value: 0x34

always_ff @(negedge clk) begin
    if (reset) begin
        q <= RESET_VALUE; // Reset q to 0x34 on active high reset
    end else begin
        q <= d; // Update q with input d on negative clock edge
    end
end

endmodule