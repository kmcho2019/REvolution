module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (shift_ena) begin
        q <= {data, q[3:1]};
    end else if (count_ena) begin
        q <= q - 4'd1;
    end
    // else hold q
end

endmodule