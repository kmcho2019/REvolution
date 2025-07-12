module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Internal binary counter
reg [15:0] binary_count;
wire [15:0] next_count;

// Gray code conversion
always @(*) begin
    count = {binary_count[15], binary_count[15:1] ^ binary_count[14:0]};
end

// Carry-lookahead inspired counting
assign next_count = up_down ? binary_count + 1'b1 : binary_count - 1'b1;

always @(posedge clk) begin
    if (reset) begin
        binary_count <= 16'b0;
    end else begin
        binary_count <= next_count;
    end
end

endmodule