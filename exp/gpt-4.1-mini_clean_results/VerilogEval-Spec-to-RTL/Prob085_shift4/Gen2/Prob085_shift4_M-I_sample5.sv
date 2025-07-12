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
    casez ({load, ena})
        2'b1?: next_q = data;              // load has priority
        2'b01: next_q = {1'b0, q[3:1]};   // shift right with zero insert
        default: next_q = q;               // hold current state
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0000;
    end else begin
        q <= next_q;
    end
end

endmodule