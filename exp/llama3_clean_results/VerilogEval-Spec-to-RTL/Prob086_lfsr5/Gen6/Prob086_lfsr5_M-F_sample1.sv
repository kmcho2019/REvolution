module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

reg [4:0] current_state;
reg [4:0] next_state;

always @(*) begin
    next_state[4] = current_state[4] ^ current_state[0];
    next_state[3] = current_state[3] ^ current_state[0];
    next_state[2] = current_state[2];
    next_state[1] = current_state[1];
    next_state[0] = current_state[4];
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= 5'b10001;
    end else begin
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule