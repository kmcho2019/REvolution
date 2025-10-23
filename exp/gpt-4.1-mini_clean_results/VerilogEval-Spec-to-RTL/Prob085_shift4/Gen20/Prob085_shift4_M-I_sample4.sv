module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

wire update_en = load | ena;
wire [3:0] next_q = load ? data : {1'b0, q[3:1]};

always @(posedge clk or posedge areset) begin
    if (areset)
        q <= 4'b0;
    else if (update_en)
        q <= next_q;
end

endmodule