module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] current_state;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= 5'b10000; // Reset to a value that will generate the maximum-length sequence
    end else begin
        current_state <= {current_state[2] ^ current_state[4], current_state[3:0]};
    end
end

assign q = current_state;

endmodule