module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

reg [3:0] next_q;
wire [3:0] shifted_q;

assign shifted_q = {1'b0, q[3:1]};

always @(*) begin
    if (load)
        next_q = data;        // load has highest priority
    else if (ena)
        next_q = shifted_q;   // shift right if enabled and no load
    else
        next_q = q;           // hold state if neither load nor ena asserted
end

always @(posedge clk or posedge areset) begin
    if (areset)
        q <= 4'b0;
    else
        q <= next_q;
end

endmodule