module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Function to compute next state of a cell according to Rule 110
    function rule110_cell;
        input left, center, right;
        reg [2:0] pattern;
        begin
            pattern = {left, center, right};
            case(pattern)
                3'b111: rule110_cell = 1'b0;
                3'b110: rule110_cell = 1'b1;
                3'b101: rule110_cell = 1'b1;
                3'b100: rule110_cell = 1'b0;
                3'b011: rule110_cell = 1'b1;
                3'b010: rule110_cell = 1'b1;
                3'b001: rule110_cell = 1'b1;
                3'b000: rule110_cell = 1'b0;
                default: rule110_cell = 1'b0;
            endcase
        end
    endfunction

    reg [511:0] next_q;

    integer i;
    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            // For left neighbor, q[i+1], zero if i=511 (boundary)
            // For right neighbor, q[i-1], zero if i=0 (boundary)
            next_q[i] = rule110_cell(
                (i == 511) ? 1'b0 : q[i+1],
                q[i],
                (i == 0) ? 1'b0 : q[i-1]
            );
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