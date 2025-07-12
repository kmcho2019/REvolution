module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // Individual history registers for each bit
    reg prev_in_0, prev_in_1, prev_in_2, prev_in_3;
    reg prev_in_4, prev_in_5, prev_in_6, prev_in_7;

    always @(posedge clk) begin
        // Bit 0 edge detection
        anyedge[0] <= in[0] ^ prev_in_0;
        prev_in_0 <= in[0];

        // Bit 1 edge detection
        anyedge[1] <= in[1] ^ prev_in_1;
        prev_in_1 <= in[1];

        // Bit 2 edge detection
        anyedge[2] <= in[2] ^ prev_in_2;
        prev_in_2 <= in[2];

        // Bit 3 edge detection
        anyedge[3] <= in[3] ^ prev_in_3;
        prev_in_3 <= in[3];

        // Bit 4 edge detection
        anyedge[4] <= in[4] ^ prev_in_4;
        prev_in_4 <= in[4];

        // Bit 5 edge detection
        anyedge[5] <= in[5] ^ prev_in_5;
        prev_in_5 <= in[5];

        // Bit 6 edge detection
        anyedge[6] <= in[6] ^ prev_in_6;
        prev_in_6 <= in[6];

        // Bit 7 edge detection
        anyedge[7] <= in[7] ^ prev_in_7;
        prev_in_7 <= in[7];
    end

endmodule