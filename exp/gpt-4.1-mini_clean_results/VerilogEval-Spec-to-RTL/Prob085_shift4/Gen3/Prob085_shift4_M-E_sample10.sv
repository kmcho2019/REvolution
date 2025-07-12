module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;
    end else begin
        case (1'b1)
            load: q <= data;
            ena:  q <= {1'b0, q[3:1]};
            default: q <= q;
        endcase
    end
end

endmodule