// Simplified TopModule with Shift Register
module TopModule(
    input clk,
    input resetn,
    input in,
    output reg out
);

reg [3:0] data;

always @(posedge clk) begin
    if (!resetn) begin
        data <= 4'b0000;
    end else begin
        data <= {data[2:0], in};
    end
    out <= data[3];
end

endmodule