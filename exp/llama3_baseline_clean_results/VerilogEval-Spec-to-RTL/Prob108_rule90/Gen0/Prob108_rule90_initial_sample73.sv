module TopModule(
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= {current_state[510:0], ~(^{current_state[511], 1'b0, current_state[0]})};
        for (int i = 1; i < 511; i++) begin
            current_state[i] <= current_state[i-1] ^ current_state[i+1];
        end
    end
end

assign q = current_state;

endmodule