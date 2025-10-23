module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Combinational next state calculation
    wire [511:0] next_q;

    // Rule 110 lookup table (3-bit input to 1-bit output)
    function automatic rule110_lut;
        input [2:0] neighbors;
        begin
            case (neighbors)
                3'b111: rule110_lut = 1'b0;
                3'b110: rule110_lut = 1'b1;
                3'b101: rule110_lut = 1'b1;
                3'b100: rule110_lut = 1'b0;
                3'b011: rule110_lut = 1'b1;
                3'b010: rule110_lut = 1'b1;
                3'b001: rule110_lut = 1'b1;
                3'b000: rule110_lut = 1'b0;
                default: rule110_lut = 1'b0;
            endcase
        end
    endfunction

    // Generate next state for each bit
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110
            // Get neighbors with boundary conditions
            wire left = (i == 511) ? 1'b0 : q[i+1];
            wire center = q[i];
            wire right = (i == 0) ? 1'b0 : q[i-1];
            
            // Use LUT function for cleaner logic
            assign next_q[i] = rule110_lut({left, center, right});
        end
    endgenerate

    // State transition logic with clock gating optimization
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Only update bits that will change
            for (integer j = 0; j < 512; j = j + 1) begin
                if (next_q[j] != q[j]) begin
                    q[j] <= next_q[j];
                end
            end
        end
    end

endmodule