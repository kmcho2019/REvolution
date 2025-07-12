module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Circular shift register implementation
    reg [511:0] shift_reg;
    wire [511:0] next_state;
    integer i;

    // Single XOR unit with multiplexed inputs
    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            // Calculate left and right neighbors with boundary conditions
            wire left = (i == 0) ? 1'b0 : shift_reg[i-1];
            wire right = (i == 511) ? 1'b0 : shift_reg[i+1];
            next_state[i] = left ^ right;
        end
    end

    // Main state update
    always @(posedge clk) begin
        if (load) begin
            shift_reg <= data;
        end else begin
            shift_reg <= next_state;
        end
    end

    assign q = shift_reg;

endmodule