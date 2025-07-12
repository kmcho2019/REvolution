module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

// Shift register to hold the current state
reg [511:0] shift_reg;

always @(posedge clk) begin
    if (load) begin
        shift_reg <= data;
    end else begin
        // Calculate next state using XOR of neighbors
        reg [511:0] next_state;
        for (int i = 0; i < 512; i++) begin
            reg left, right;
            if (i == 0) begin
                left = 1'b0;
                right = (i == 511)? 1'b0 : shift_reg[i + 1];
            end else if (i == 511) begin
                left = shift_reg[i - 1];
                right = 1'b0;
            end else begin
                left = shift_reg[i - 1];
                right = shift_reg[i + 1];
            end
            next_state[i] = left ^ right;
        end
        shift_reg <= next_state;
    end
end

assign q = shift_reg;

endmodule