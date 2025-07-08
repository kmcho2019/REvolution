module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Function to compute next state of a single cell based on Rule 110
    function automatic bit rule110_next_state;
        input bit left;
        input bit center;
        input bit right;
        begin
            // Construct the 3-bit pattern left-center-right as a 3-bit number
            // and map according to Rule 110:
            // Pattern: 111 110 101 100 011 010 001 000
            // Output :  0   1   1   0   1   1   1   0
            case ({left, center, right})
                3'b111: rule110_next_state = 1'b0;
                3'b110: rule110_next_state = 1'b1;
                3'b101: rule110_next_state = 1'b1;
                3'b100: rule110_next_state = 1'b0;
                3'b011: rule110_next_state = 1'b1;
                3'b010: rule110_next_state = 1'b1;
                3'b001: rule110_next_state = 1'b1;
                3'b000: rule110_next_state = 1'b0;
                default: rule110_next_state = 1'b0;
            endcase
        end
    endfunction

    reg [511:0] next_q;

    integer i;
    always @* begin
        for (i = 0; i < 512; i = i + 1) begin
            bit left, center, right;
            // Boundary conditions: q[-1] = 0, q[512] = 0
            left   = (i == 511) ? 1'b0 : q[i+1];
            center = q[i];
            right  = (i == 0) ? 1'b0 : q[i-1];
            next_q[i] = rule110_next_state(left, center, right);
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