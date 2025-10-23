module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg; // Internal register to hold the current state

assign q = q_reg; // Assign output to internal register

always @(posedge clk) begin
    if (load) begin
        // Load the initial state from data port
        q_reg <= data;
    end else begin
        // Calculate next state based on Rule 90
        for (int i = 0; i < 512; i++) begin
            if (i == 0) begin
                // Left boundary: assume left neighbor is always 0
                q_reg[i] <= q_reg[i] ^ q_reg[i+1];
            end else if (i == 511) begin
                // Right boundary: assume right neighbor is always 0
                q_reg[i] <= q_reg[i-1] ^ q_reg[i];
            end else begin
                // Calculate next state based on left and right neighbors
                q_reg[i] <= q_reg[i-1] ^ q_reg[i+1];
            end
        end
    end
end

endmodule