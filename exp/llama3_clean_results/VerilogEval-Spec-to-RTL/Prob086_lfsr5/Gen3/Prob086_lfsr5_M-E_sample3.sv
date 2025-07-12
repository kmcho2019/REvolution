module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

parameter WIDTH = 5;
parameter TAP1 = 4;
parameter TAP2 = 2;

reg [WIDTH-1:0] current_state;
reg [WIDTH-1:0] next_state;

assign q = current_state;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= 1;
    end else begin
        current_state <= next_state;
    end
end

always @ (*) begin
    next_state = {current_state[TAP1] ^ current_state[TAP2] ^ current_state[0], current_state[WIDTH-1:1]};
end

endmodule