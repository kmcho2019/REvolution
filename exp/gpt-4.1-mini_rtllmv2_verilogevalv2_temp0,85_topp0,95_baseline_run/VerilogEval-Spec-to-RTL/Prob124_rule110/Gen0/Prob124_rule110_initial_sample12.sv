module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Function to compute next state bit given left, center, right bits
    // Using the given truth table:
    // (Left,Center,Right) -> nextCenter
    // 111 -> 0
    // 110 -> 1
    // 101 -> 1
    // 100 -> 0
    // 011 -> 1
    // 010 -> 1
    // 001 -> 1
    // 000 -> 0
    function automatic logic rule110(
        input logic left,
        input logic center,
        input logic right
    );
        begin
            case ({left, center, right})
                3'b111: rule110 = 1'b0;
                3'b110: rule110 = 1'b1;
                3'b101: rule110 = 1'b1;
                3'b100: rule110 = 1'b0;
                3'b011: rule110 = 1'b1;
                3'b010: rule110 = 1'b1;
                3'b001: rule110 = 1'b1;
                3'b000: rule110 = 1'b0;
                default: rule110 = 1'b0; // Defensive, should never happen
            endcase
        end
    endfunction

    integer i;
    reg [511:0] next_state;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Compute next state for all cells
            // Boundary neighbors assumed 0
            // left = q[i+1], center = q[i], right = q[i-1]
            // For i=0, right neighbor is 0
            // For i=511, left neighbor is 0
            for (i = 0; i < 512; i = i + 1) begin
                // left neighbor
                logic left = (i == 511) ? 1'b0 : q[i+1];
                // center
                logic center = q[i];
                // right neighbor
                logic right = (i == 0) ? 1'b0 : q[i-1];
                next_state[i] = rule110(left, center, right);
            end
            q <= next_state;
        end
    end

endmodule