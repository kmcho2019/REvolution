module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

parameter INIT_VAL = 5'b00001;

always @(posedge clk) begin
    if (reset) begin
        q <= INIT_VAL;
    end else begin
        q <= {q[0], q[4], q[2] ^ q[0], q[2:1]};
    end
end

endmodule