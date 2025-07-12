module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;
reg [511:0] left_shift;
reg [511:0] right_shift;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        // Shift the current state of the cells one position to the left and right
        left_shift[0] = 0; // Left boundary
        for (int i = 1; i < 512; i++) begin
            left_shift[i] = q_reg[i-1];
        end
        right_shift[511] = 0; // Right boundary
        for (int i = 0; i < 511; i++) begin
            right_shift[i] = q_reg[i+1];
        end
        // Calculate the next state of each cell using the current state and the shifted values
        for (int i = 0; i < 512; i++) begin
            q_reg[i] <= left_shift[i] ^ right_shift[i];
        end
    end
end

assign q = q_reg;

endmodule