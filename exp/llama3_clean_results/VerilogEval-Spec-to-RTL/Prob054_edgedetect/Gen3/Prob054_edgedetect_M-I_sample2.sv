module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in; // register to store the previous value of in

always @(posedge clk) begin
    prev_in <= in; // update the previous value on every clock cycle
    for (int i = 0; i < 8; i++) begin
        pedge[i] <= prev_in[i] == 0 && in[i] == 1; // directly assign the result of the edge detection
    end
end

endmodule