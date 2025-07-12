module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

localparam IDLE = 4;
localparam MAX = 6;

always @(posedge clk) begin
    if (a) begin
        q <= IDLE;
    end else if (q < MAX - 1) begin
        q <= q + 1;
    end else begin
        q <= 0;
    end
end

// Initialize the output
initial q = IDLE;

endmodule