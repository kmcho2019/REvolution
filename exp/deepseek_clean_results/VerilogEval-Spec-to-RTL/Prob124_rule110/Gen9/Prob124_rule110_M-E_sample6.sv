module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Circular shift registers for neighbors
    wire [511:0] left_neighbor = {q[0], q[511:1]};  // Circular left shift
    wire [511:0] right_neighbor = {q[510:0], q[511]}; // Circular right shift

    // LUT for Rule 110 (8 possible patterns)
    function automatic lut_rule110;
        input [2:0] pattern;
        begin
            case(pattern)
                3'b111: lut_rule110 = 1'b0;
                3'b110: lut_rule110 = 1'b1;
                3'b101: lut_rule110 = 1'b1;
                3'b100: lut_rule110 = 1'b0;
                3'b011: lut_rule110 = 1'b1;
                3'b010: lut_rule110 = 1'b1;
                3'b001: lut_rule110 = 1'b1;
                3'b000: lut_rule110 = 1'b0;
            endcase
        end
    endfunction

    // Compute next state in parallel
    wire [511:0] next_q;
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110
            // Form 3-bit neighborhood pattern
            wire [2:0] neighborhood = {left_neighbor[i], q[i], right_neighbor[i]};
            
            // Get next state from LUT
            assign next_q[i] = lut_rule110(neighborhood);
        end
    endgenerate

    // State transition logic
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule