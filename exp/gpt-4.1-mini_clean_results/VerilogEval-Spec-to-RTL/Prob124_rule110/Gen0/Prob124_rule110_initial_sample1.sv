module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Function to calculate next state of a cell according to Rule 110
    // Inputs: left, center, right (each 1 bit)
    // Returns: next center state (1 bit)
    function automatic bit rule110_cell(
        input bit left,
        input bit center,
        input bit right
    );
        // Neighborhood 3-bit pattern: {left, center, right}
        // The rule110 truth table mapping to next state:
        // 111 -> 0
        // 110 -> 1
        // 101 -> 1
        // 100 -> 0
        // 011 -> 1
        // 010 -> 1
        // 001 -> 1
        // 000 -> 0
        begin
            case ({left, center, right})
                3'b111: rule110_cell = 0;
                3'b110: rule110_cell = 1;
                3'b101: rule110_cell = 1;
                3'b100: rule110_cell = 0;
                3'b011: rule110_cell = 1;
                3'b010: rule110_cell = 1;
                3'b001: rule110_cell = 1;
                3'b000: rule110_cell = 0;
                default: rule110_cell = 0; // default safety
            endcase
        end
    endfunction

    reg [511:0] next_q;

    integer i;

    always @* begin
        // Combinational logic to compute next_q from current q
        for (i = 0; i < 512; i = i + 1) begin
            // Left neighbor is q[i+1], or 0 if i+1 > 511
            bit left = (i < 511) ? q[i+1] : 1'b0;
            // Center is q[i]
            bit center = q[i];
            // Right neighbor is q[i-1], or 0 if i-1 < 0
            bit right = (i > 0) ? q[i-1] : 1'b0;

            next_q[i] = rule110_cell(left, center, right);
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule