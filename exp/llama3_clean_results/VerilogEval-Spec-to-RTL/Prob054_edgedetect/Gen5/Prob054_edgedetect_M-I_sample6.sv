module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in; // register to store the previous value of in

always @(posedge clk) begin
    if (in != prev_in) begin // only update prev_in when input changes
        prev_in <= in;
    end
    for (int i = 0; i < 8; i++) begin
        pedge[i] <= ~prev_in[i] && in[i]; // use a loop to generate edge detection logic
    end
end

endmodule