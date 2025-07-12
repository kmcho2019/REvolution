module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

reg [3:0] next_q;

always @(*) begin
    if (load) begin
        next_q = data;              // load has highest priority
    end else if (ena) begin
        next_q = {1'b0, q[3:1]};   // shift right with zero fill at MSB
    end else begin
        next_q = q;                // hold current value
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;                 // asynchronous reset to zero
    end else begin
        q <= next_q;               // update register with next state
    end
end

endmodule