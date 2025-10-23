module TopModule(
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg; // Register to store the current state

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        reg [511:0] next_state;
        
        // Calculate next state for each cell
        for (int i = 0; i < 512; i++) begin
            if (i == 0) begin
                next_state[i] = q_reg[0] ^ q_reg[1]; // Left neighbor is always 0
            end else if (i == 511) begin
                next_state[i] = q_reg[510] ^ q_reg[511]; // Right neighbor is always 0
            end else begin
                next_state[i] = q_reg[i-1] ^ q_reg[i+1];
            end
        end
        
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule