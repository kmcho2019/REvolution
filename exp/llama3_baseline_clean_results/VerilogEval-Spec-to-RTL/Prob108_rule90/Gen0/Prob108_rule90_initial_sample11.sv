module TopModule(
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

assign q = current_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        for (int i = 0; i < 512; i++) begin
            if (i == 0) begin
                next_state[i] <= (1'b0 ^ current_state[i] ^ (i + 1 < 512) ? current_state[i + 1] : 1'b0);
            end else if (i == 511) begin
                next_state[i] <= (current_state[i - 1] ^ current_state[i] ^ 1'b0);
            end else begin
                next_state[i] <= (current_state[i - 1] ^ current_state[i] ^ current_state[i + 1]);
            end
        end
        current_state <= next_state;
    end
end

initial begin
    current_state = 0;
    next_state = 0;
end

endmodule