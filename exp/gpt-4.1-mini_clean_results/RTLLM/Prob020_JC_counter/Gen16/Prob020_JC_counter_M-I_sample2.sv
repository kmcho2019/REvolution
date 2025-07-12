module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

wire msb_next;

assign msb_next = ~Q[0];

wire [63:0] Q_next = {msb_next, Q[63:1]};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        Q <= Q_next;
    end
end

endmodule