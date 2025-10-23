module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk,
    input rst_n // Active low reset
);

reg [3:0] counter; // Assuming 4-bit counter is sufficient for the period
always @(*) begin
    if (~rst_n) begin // Active low reset
        counter <= 4'd0;
        clk <= 1'b0;
    end else if (counter == (PERIOD / 2)) begin
        counter <= 4'd0;
        clk <= ~clk;
    end else begin
        counter <= counter + 1'b1;
    end
end

// Alternatively, using a more straightforward approach with a single flip-flop
// module clkgenerator #(parameter PERIOD = 10)(output reg clk, input rst_n);
// reg clk;
// always @(posedge clk or negedge rst_n) begin
//     if (~rst_n) begin
//         clk <= 1'b0;
//     end else begin
//         clk <= ~clk after (PERIOD / 2);
//     end
// end
endmodule