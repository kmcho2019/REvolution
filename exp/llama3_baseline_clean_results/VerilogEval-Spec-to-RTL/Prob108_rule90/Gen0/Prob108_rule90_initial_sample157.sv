module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg; // internal register to store the current state

assign q = q_reg; // assign the output to the internal register

always @(posedge clk) begin
    if (load) begin
        q_reg <= data; // load the data into the internal register when load is high
    end else begin
        for (int i = 0; i < 512; i++) begin
            // calculate the next state of each cell based on the XOR of its two current neighbors
            if (i == 0) begin
                q_reg[i] <= q_reg[i+1]; // left boundary, only consider the right neighbor
            end else if (i == 511) begin
                q_reg[i] <= q_reg[i-1]; // right boundary, only consider the left neighbor
            end else begin
                q_reg[i] <= q_reg[i-1] ^ q_reg[i+1]; // calculate the next state based on both neighbors
            end
        end
    end
end

endmodule