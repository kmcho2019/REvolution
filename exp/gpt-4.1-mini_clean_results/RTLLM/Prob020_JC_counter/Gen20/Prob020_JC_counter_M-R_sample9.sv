module JC_counter (
    input  wire       clk,
    input  wire       rst_n,
    output reg [63:0] Q
);

// Next state combinational logic
wire [63:0] Q_next;
assign Q_next = {~Q[0], Q[63:1]};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        Q <= 64'b0;
    else
        Q <= Q_next;
end

endmodule