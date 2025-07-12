module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg; // register to store the current state

always @(posedge clk) begin
    if (load) begin
        q_reg <= data; // load the initial state
    end else begin
        // calculate the next state using Rule 90
        for (int i = 0; i < 512; i++) begin
            if (i == 0) begin
                q_reg[i] <= q_reg[i + 1]; // left boundary is always 0
            end else if (i == 511) begin
                q_reg[i] <= q_reg[i - 1]; // right boundary is always 0
            end else begin
                q_reg[i] <= q_reg[i - 1] ^ q_reg[i + 1]; // XOR of left and right neighbors
            end
        end
    end
end

assign q = q_reg; // output the current state

endmodule