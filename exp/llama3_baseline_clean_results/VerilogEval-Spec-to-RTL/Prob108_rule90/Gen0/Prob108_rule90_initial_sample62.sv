module TopModule(
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg; // register to store the current state of the system

// load mechanism
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        // calculate the next state of each cell
        for (int i = 0; i < 512; i++) begin
            if (i == 0) begin
                // left boundary is zero
                q_reg[i] <= (q_reg[i] ^ q_reg[i+1]);
            end else if (i == 511) begin
                // right boundary is zero
                q_reg[i] <= (q_reg[i-1] ^ q_reg[i]);
            end else begin
                // interior cells
                q_reg[i] <= (q_reg[i-1] ^ q_reg[i+1]);
            end
        end
    end
end

// assign output
assign q = q_reg;

endmodule