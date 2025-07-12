module TopModule(
    input clk,
    input rst_n, // Asynchronous active-low reset
    input [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset q to all zeros on reset
            q <= 8'd0;
        end else begin
            // Update q on the positive edge of the clock
            q <= d;
        end
    end

endmodule