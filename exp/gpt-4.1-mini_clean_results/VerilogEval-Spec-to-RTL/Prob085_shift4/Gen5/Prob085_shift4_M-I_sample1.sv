module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

wire ce = load | ena; // clock enable to reduce register toggling

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;
    end else if (ce) begin
        q <= load ? data : {1'b0, q[3:1]};
    end
    // else retain q, no clocked update for power saving
end

endmodule