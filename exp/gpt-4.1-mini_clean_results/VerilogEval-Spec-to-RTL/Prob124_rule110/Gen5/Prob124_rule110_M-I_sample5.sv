module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Rule 110 lookup table for 3-bit neighborhood: {left, center, right}
    // Index: {left, center, right} as 3-bit number, MSB=left, LSB=right
    // For example, neighborhood 3'b111 = 7 -> 0, as per rule table
    localparam [7:0] RULE110_LUT = 8'b01101110;
    // Index: 7 6 5 4 3 2 1 0
    // Data:  0 1 1 0 1 1 1 0

    wire [511:0] next_q;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : next_state_gen
            wire left = (i == 511) ? 1'b0 : q[i+1];
            wire center = q[i];
            wire right = (i == 0) ? 1'b0 : q[i-1];
            wire [2:0] neighborhood = {left, center, right};
            assign next_q[i] = RULE110_LUT[neighborhood];
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule