module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [7:0] seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter to 0 when rst_n is low
        seg0 <= 8'd0;
        seg1 <= 8'd0;
        seg2 <= 8'd0;
        seg3 <= 8'd0;
        seg4 <= 8'd0;
        seg5 <= 8'd0;
        seg6 <= 8'd0;
        seg7 <= 8'd0;
    end else begin
        // Determine the next state based on the current least significant bit
        if (Q[0] == 1'b0) begin
            // If the least significant bit is 0, shift right and append 1
            seg7 <= {1'b1, seg7[7:1]};
            seg6 <= {seg7[0], seg6[7:1]};
            seg5 <= {seg6[0], seg5[7:1]};
            seg4 <= {seg5[0], seg4[7:1]};
            seg3 <= {seg4[0], seg3[7:1]};
            seg2 <= {seg3[0], seg2[7:1]};
            seg1 <= {seg2[0], seg1[7:1]};
            seg0 <= {seg1[0], seg0[7:1]};
        end else begin
            // If the least significant bit is 1, shift right and append 0
            seg7 <= {1'b0, seg7[7:1]};
            seg6 <= {seg7[0], seg6[7:1]};
            seg5 <= {seg6[0], seg5[7:1]};
            seg4 <= {seg5[0], seg4[7:1]};
            seg3 <= {seg4[0], seg3[7:1]};
            seg2 <= {seg3[0], seg2[7:1]};
            seg1 <= {seg2[0], seg1[7:1]};
            seg0 <= {seg1[0], seg0[7:1]};
        end
    end
    // Concatenate the segments to form the 64-bit state
    Q <= {seg7, seg6, seg5, seg4, seg3, seg2, seg1, seg0};
end

endmodule