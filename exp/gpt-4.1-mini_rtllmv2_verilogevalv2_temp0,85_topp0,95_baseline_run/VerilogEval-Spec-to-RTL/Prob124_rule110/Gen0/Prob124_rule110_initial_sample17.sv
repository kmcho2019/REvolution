module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Function to compute next state of a cell given left, center, right bits
    function rule110;
        input left, center, right;
        begin
            // Form 3-bit pattern: {left, center, right}
            // According to Rule 110 table:
            // 111->0, 110->1, 101->1, 100->0, 011->1, 010->1, 001->1, 000->0
            case ({left, center, right})
                3'b111: rule110 = 1'b0;
                3'b110: rule110 = 1'b1;
                3'b101: rule110 = 1'b1;
                3'b100: rule110 = 1'b0;
                3'b011: rule110 = 1'b1;
                3'b010: rule110 = 1'b1;
                3'b001: rule110 = 1'b1;
                3'b000: rule110 = 1'b0;
                default: rule110 = 1'b0; // default case
            endcase
        end
    endfunction

    integer i;
    reg [511:0] next_q;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Compute next state for each bit
            for (i = 0; i < 512; i = i + 1) begin
                // Determine neighbors with boundary zero
                // Left neighbor is q[i+1], zero if i==511
                // Center is q[i]
                // Right neighbor is q[i-1], zero if i==0
                reg left, center, right;
                left = (i == 511) ? 1'b0 : q[i+1];
                center = q[i];
                right = (i == 0) ? 1'b0 : q[i-1];
                next_q[i] = rule110(left, center, right);
            end
            q <= next_q;
        end
    end

endmodule