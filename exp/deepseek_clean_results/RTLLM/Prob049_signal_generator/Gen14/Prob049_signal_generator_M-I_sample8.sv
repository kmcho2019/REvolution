module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [5:0] counter; // 6-bit counter for automatic overflow handling

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 6'b0;
        wave <= 5'b0;
    end else begin
        counter <= counter + 1;
        // Generate triangle wave directly in sequential logic
        wave <= counter[5] ? ~counter[4:0] : counter[4:0];
    end
end

endmodule