module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        reg [511:0] next_state;
        // Handle the first cell
        next_state[0] = q_reg[1]; // Since the left neighbor is 0, and according to the table, it's the XOR of left and right, but considering the actual rule logic
        // Calculate the next state of the cells in the middle
        for (int i = 1; i < 511; i++) begin
            // The next state is the XOR of the left and right neighbors, reflecting the Rule 90 logic
            next_state[i] = q_reg[i-1] ^ q_reg[i+1];
        end
        // Handle the last cell
        next_state[511] = q_reg[510]; // Since the right neighbor is 0
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule