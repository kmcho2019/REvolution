module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;
reg [511:0] next_state_reg;

integer i;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
        next_state_reg <= 512'b0; // Reset next_state_reg when loading new data
    end else begin
        next_state_reg <= 512'b0; // Initialize next_state_reg with zeros
        for (i = 0; i < 512; i++) begin
            if (i == 0) begin
                next_state_reg[i] <= q_reg[i] ^ q_reg[i+1]; // Left boundary is '0'
            end else if (i == 511) begin
                next_state_reg[i] <= q_reg[i-1] ^ q_reg[i]; // Right boundary is '0'
            end else begin
                next_state_reg[i] <= q_reg[i-1] ^ q_reg[i] ^ q_reg[i+1];
            end
        end
        q_reg <= next_state_reg; // Update q_reg with the next state
    end
end

assign q = q_reg;

endmodule