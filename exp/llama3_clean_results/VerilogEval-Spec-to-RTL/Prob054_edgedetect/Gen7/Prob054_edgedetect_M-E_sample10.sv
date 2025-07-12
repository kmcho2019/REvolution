module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in;  // register to store the previous state of the input signal
reg [7:0] edge_detected;  // register to store the edge detection result

always @(posedge clk) begin
    prev_in <= in;  // update the previous state
end

always @(*) begin
    for (int i = 0; i < 8; i++) begin
        edge_detected[i] = in[i] && ~prev_in[i];  // detect 0 to 1 transition using bitwise AND
    end
    pedge <= edge_detected;  // assign the edge detection result to the output
end

endmodule