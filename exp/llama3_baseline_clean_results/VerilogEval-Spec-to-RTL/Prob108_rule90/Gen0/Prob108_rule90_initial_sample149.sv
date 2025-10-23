module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        for (int i = 0; i < 512; i++) begin
            if (i == 0) begin
                // left boundary is always 0
                current_state[i] <= current_state[i + 1];
            end else if (i == 511) begin
                // right boundary is always 0
                current_state[i] <= current_state[i - 1];
            end else begin
                // interior cells
                current_state[i] <= current_state[i - 1] ^ current_state[i + 1];
            end
        end
    end
end

assign q = current_state;

endmodule