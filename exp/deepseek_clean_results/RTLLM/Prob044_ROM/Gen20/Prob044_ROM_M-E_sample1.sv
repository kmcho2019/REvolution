module ROM (
    input [7:0] addr,
    output [15:0] dout
);

    // Address decode signals
    wire is_addr0 = (addr == 8'd0);
    wire is_addr1 = (addr == 8'd1);
    wire is_addr2 = (addr == 8'd2);
    wire is_addr3 = (addr == 8'd3);

    // Pattern generation
    wire [15:0] pattern0 = 16'hA0A0;
    wire [15:0] pattern1 = {8'hB1, 8'hB1};
    wire [15:0] pattern2 = {8'hC2, 8'hC2};
    wire [15:0] pattern3 = {8'hD3, 8'hD3};

    // Output selection logic
    assign dout = (is_addr0) ? pattern0 :
                 (is_addr1) ? pattern1 :
                 (is_addr2) ? pattern2 :
                 (is_addr3) ? pattern3 :
                 16'h0000;  // Default value for other addresses

endmodule