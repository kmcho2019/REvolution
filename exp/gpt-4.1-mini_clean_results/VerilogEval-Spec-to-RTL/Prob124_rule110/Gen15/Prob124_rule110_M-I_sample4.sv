module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_state_stage1; // Pipeline stage 1 output

    // LUT function for Rule 110 next state
    // Neighborhood encoded as {left, center, right} bits, 3-bit input
    // The next state values per the rule:
    // 111->0, 110->1, 101->1, 100->0, 011->1, 010->1, 001->1, 000->0
    function automatic bit rule110_lut(input [2:0] pattern);
        begin
            case(pattern)
                3'b111: rule110_lut = 1'b0;
                3'b110: rule110_lut = 1'b1;
                3'b101: rule110_lut = 1'b1;
                3'b100: rule110_lut = 1'b0;
                3'b011: rule110_lut = 1'b1;
                3'b010: rule110_lut = 1'b1;
                3'b001: rule110_lut = 1'b1;
                3'b000: rule110_lut = 1'b0;
                default: rule110_lut = 1'b0; // Should never occur
            endcase
        end
    endfunction

    integer i;

    // Combinational logic stage to compute next state per cell
    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            // Get neighbors with boundary conditions = 0
            bit left = (i == 511) ? 1'b0 : q[i+1];
            bit center = q[i];
            bit right = (i == 0) ? 1'b0 : q[i-1];
            next_state_stage1[i] = rule110_lut({left, center, right});
        end
    end

    // Pipeline registers: Update q on posedge clk
    always @(posedge clk) begin
        if (load) begin
            q <= data;               // Load input data immediately
        end else begin
            q <= next_state_stage1;  // Update all cells simultaneously (pipeline stage)
        end
    end

endmodule