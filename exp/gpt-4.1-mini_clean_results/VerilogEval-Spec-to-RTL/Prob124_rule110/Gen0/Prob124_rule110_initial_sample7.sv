module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Function to calculate next state of one cell according to Rule 110
    function automatic bit next_cell_state(
        input bit left,
        input bit center,
        input bit right
    );
        // Truth table:
        // Left Center Right | Next
        // 1    1      1    | 0
        // 1    1      0    | 1
        // 1    0      1    | 1
        // 1    0      0    | 0
        // 0    1      1    | 1
        // 0    1      0    | 1
        // 0    0      1    | 1
        // 0    0      0    | 0
        begin
            case ({left, center, right})
                3'b111: next_cell_state = 1'b0;
                3'b110: next_cell_state = 1'b1;
                3'b101: next_cell_state = 1'b1;
                3'b100: next_cell_state = 1'b0;
                3'b011: next_cell_state = 1'b1;
                3'b010: next_cell_state = 1'b1;
                3'b001: next_cell_state = 1'b1;
                3'b000: next_cell_state = 1'b0;
                default: next_cell_state = 1'b0; // Safety default
            endcase
        end
    endfunction

    integer i;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            reg [511:0] next_q;
            for (i = 0; i < 512; i = i + 1) begin
                bit left  = (i == 511) ? 1'b0 : q[i+1];
                bit center = q[i];
                bit right = (i == 0) ? 1'b0 : q[i-1];
                next_q[i] = next_cell_state(left, center, right);
            end
            q <= next_q;
        end
    end

endmodule