module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

wire clk_en = count_ena | shift_ena;

always @(posedge clk) begin
    if (clk_en) begin
        if (count_ena)
            q <= q - 1;
        else // shift_ena only
            q <= {q[2:0], data};
    end
end

endmodule