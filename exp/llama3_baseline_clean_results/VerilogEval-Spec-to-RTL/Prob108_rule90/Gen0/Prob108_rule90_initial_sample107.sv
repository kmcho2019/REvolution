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
        current_state <= {current_state[510:0] ^ {current_state[511:1], 1'b0}, 
                          current_state[510] ^ current_state[511] ^ 1'b0};
    end
end

always @(*) begin
    q <= current_state;
end

initial begin
    current_state = 512'b0;
end

endmodule