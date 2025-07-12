module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // LUT for Rule 110 (8 possible combinations)
    reg [7:0] rule110_lut;
    initial begin
        rule110_lut[0] = 0; // 000
        rule110_lut[1] = 1; // 001
        rule110_lut[2] = 1; // 010
        rule110_lut[3] = 1; // 011
        rule110_lut[4] = 0; // 100
        rule110_lut[5] = 1; // 101
        rule110_lut[6] = 1; // 110
        rule110_lut[7] = 0; // 111
    end

    reg [511:0] next_q;
    genvar i;

    // Process internal bits (510 bits) in parallel segments
    generate
        for (i = 1; i < 511; i = i + 1) begin : internal_bits
            wire [2:0] neighborhood = {q[i+1], q[i], q[i-1]};
            always @(*) begin
                next_q[i] = rule110_lut[neighborhood];
            end
        end
    endgenerate

    // Process boundary bits separately
    always @(*) begin
        // Left boundary (bit 0)
        next_q[0] = rule110_lut[{q[1], q[0], 1'b0}];
        
        // Right boundary (bit 511)
        next_q[511] = rule110_lut[{1'b0, q[511], q[510]}];
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule