module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count = 8'd0;

always @(posedge clk) begin
    if (count == (freq - 1)) begin // Optimized comparison to avoid unnecessary increment
        count <= 8'd0;
        wave_out <= ~wave_out;
    end else begin
        count <= count + 8'd1;
    end
end

// Optional reset logic for better reliability and predictability
// always @(posedge clk or posedge rst_n) begin
//     if (~rst_n) begin
//         count <= 8'd0;
//         wave_out <= 1'b0;
//     end else begin
//         // Existing logic here
//     end
// end

endmodule