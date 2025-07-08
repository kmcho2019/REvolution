module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Function to compute next state of one cell according to Rule 110
    // Input: 3-bit vector {left, center, right}
    // Output: next center state (1 bit)
    function automatic bit rule110(input bit [2:0] triplet);
        begin
            // According to the table:
            // triplet pattern: {left, center, right}
            // 111 -> 0
            // 110 -> 1
            // 101 -> 1
            // 100 -> 0
            // 011 -> 1
            // 010 -> 1
            // 001 -> 1
            // 000 -> 0
            case (triplet)
                3'b111: rule110 = 0;
                3'b110: rule110 = 1;
                3'b101: rule110 = 1;
                3'b100: rule110 = 0;
                3'b011: rule110 = 1;
                3'b010: rule110 = 1;
                3'b001: rule110 = 1;
                3'b000: rule110 = 0;
                default: rule110 = 0; // shouldn't happen
            endcase
        end
    endfunction

    integer i;
    reg [511:0] next_q;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Compute next state
            // For each bit i in [0..511]:
            // left = q[i+1] if i<511 else 0
            // center = q[i]
            // right = q[i-1] if i>0 else 0
            for (i = 0; i < 512; i = i + 1) begin
                bit left = (i < 511) ? q[i+1] : 1'b0;
                bit center = q[i];
                bit right = (i > 0) ? q[i-1] : 1'b0;
                next_q[i] = rule110({left, center, right});
            end
            q <= next_q;
        end
    end

endmodule