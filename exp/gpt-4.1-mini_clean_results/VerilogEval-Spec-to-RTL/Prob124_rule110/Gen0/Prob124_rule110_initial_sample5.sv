module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    // Function to compute next state bit of a cell according to Rule 110
    // Given left, center, right bits, return next state bit
    function rule110;
        input left, center, right;
        begin
            // Use the truth table directly
            // Compose 3-bit pattern as {left, center, right}
            case ({left, center, right})
                3'b111: rule110 = 1'b0;
                3'b110: rule110 = 1'b1;
                3'b101: rule110 = 1'b1;
                3'b100: rule110 = 1'b0;
                3'b011: rule110 = 1'b1;
                3'b010: rule110 = 1'b1;
                3'b001: rule110 = 1'b1;
                3'b000: rule110 = 1'b0;
                default: rule110 = 1'b0; // default case, should not occur
            endcase
        end
    endfunction

    reg [511:0] q_next;

    integer i;

    always @(*) begin
        for (i=0; i<512; i=i+1) begin
            // Left neighbor: q[i+1] if i+1<512 else 0
            // Right neighbor: q[i-1] if i-1>=0 else 0
            // center: q[i]
            q_next[i] = rule110(
                (i == 511) ? 1'b0 : q[i+1],
                q[i],
                (i == 0) ? 1'b0 : q[i-1]
            );
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= q_next;
    end

endmodule