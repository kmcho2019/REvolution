module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;
    end
    else begin
        casez ({load, ena})
            2'b1?: q <= data;     // load has priority
            2'b01: q <= {1'b0, q[3:1]};  // shift right
            default: q <= q;      // hold value
        endcase
    end
end

endmodule