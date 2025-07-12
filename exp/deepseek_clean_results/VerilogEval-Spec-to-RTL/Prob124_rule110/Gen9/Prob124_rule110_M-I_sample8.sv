module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Combinational next state calculation
    reg [511:0] next_q;

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
            endcase
        end
    endfunction

    // Next state calculation in a single always block
    always @(*) begin
        for (integer i = 0; i < 512; i = i + 1) begin
            // Get neighbors with boundary conditions
            reg left, right;
            left = (i == 511) ? 1'b0 : q[i+1];
            right = (i == 0) ? 1'b0 : q[i-1];
            
            // Calculate next state
            next_q[i] = rule110_lut({left, q[i], right});
        end
    end

    // State transition logic with optimized clock gating
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Update all bits at once (simpler than conditional update)
            q <= next_q;
        end
    end

endmodule