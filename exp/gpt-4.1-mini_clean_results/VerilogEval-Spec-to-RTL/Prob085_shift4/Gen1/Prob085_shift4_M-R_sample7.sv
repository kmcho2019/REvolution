module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

reg [3:0] next_q;

// Next state logic: load has priority over ena, else hold current value
always @(*) begin
    if (load) begin
        next_q = data;
    end else if (ena) begin
        next_q = {1'b0, q[3:1]};
    end else begin
        next_q = q;
    end
end

// Sequential logic with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;
    end else begin
        q <= next_q;
    end
end

endmodule