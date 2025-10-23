module right_shifter(
    input clk,
    input rst_n, // Active low reset signal
    input d,
    output reg [7:0] q = 8'b0
);

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            q <= 8'b0; // Reset the register to 0 when rst_n is low
        end else begin
            q <= {d, q[7:1]}; // Perform the right shift operation
        end
    end

endmodule