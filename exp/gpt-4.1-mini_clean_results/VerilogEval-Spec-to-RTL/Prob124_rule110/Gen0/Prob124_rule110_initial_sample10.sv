module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Combinational next state
    reg [511:0] next_state;
    integer i;

    // Rule 110 truth table as a function:
    // bits: {left, center, right} => next state bit
    // Mapping the given table (from the problem):
    // 111 -> 0
    // 110 -> 1
    // 101 -> 1
    // 100 -> 0
    // 011 -> 1
    // 010 -> 1
    // 001 -> 1
    // 000 -> 0

    function rule110;
        input [2:0] neighborhood;
        begin
            case (neighborhood)
                3'b111: rule110 = 0;
                3'b110: rule110 = 1;
                3'b101: rule110 = 1;
                3'b100: rule110 = 0;
                3'b011: rule110 = 1;
                3'b010: rule110 = 1;
                3'b001: rule110 = 1;
                3'b000: rule110 = 0;
                default: rule110 = 0; // default safe case
            endcase
        end
    endfunction

    always @* begin
        // compute next state for each bit
        for (i = 0; i < 512; i = i + 1) begin
            // get left neighbor
            reg left, center, right;
            left = (i == 511) ? 1'b0 : q[i+1];
            center = q[i];
            right = (i == 0) ? 1'b0 : q[i-1];
            next_state[i] = rule110({left, center, right});
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule