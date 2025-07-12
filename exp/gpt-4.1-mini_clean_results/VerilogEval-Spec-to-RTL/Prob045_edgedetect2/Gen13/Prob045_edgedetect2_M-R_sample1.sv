module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] in_dly;

    // Register input in_dly on clock edge
    always @(posedge clk) begin
        in_dly <= in;
    end

    // Detect edges by comparing current input to delayed input, update anyedge
    always @(posedge clk) begin
        integer i;
        for (i = 0; i < 8; i = i + 1) begin
            anyedge[i] = in[i] ^ in_dly[i];
        end
    end
endmodule