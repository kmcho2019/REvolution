module TopModule (
    input         clk,
    input         areset,
    input         load,
    input         ena,
    input  [3:0]  data,
    output reg [3:0] q
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q[0] <= 1'b0;
        q[1] <= 1'b0;
        q[2] <= 1'b0;
        q[3] <= 1'b0;
    end else if (load) begin
        q[0] <= data[0];
        q[1] <= data[1];
        q[2] <= data[2];
        q[3] <= data[3];
    end else if (ena) begin
        q[0] <= q[1];
        q[1] <= q[2];
        q[2] <= q[3];
        q[3] <= 1'b0; // shift in zero at MSB
    end // else hold current value by default (no change)
end

endmodule