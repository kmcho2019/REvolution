module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in; // register to store the previous value of in

always @(posedge clk) begin
    if (in != prev_in) begin // update the previous value only when the input changes
        prev_in <= in;
    end

    for (int i = 0; i < 8; i++) begin // use a for loop to generate the edge detection logic
        pedge[i] <= ~prev_in[i] && in[i]; // directly assign the result of the edge detection for each bit
    end
end

endmodule