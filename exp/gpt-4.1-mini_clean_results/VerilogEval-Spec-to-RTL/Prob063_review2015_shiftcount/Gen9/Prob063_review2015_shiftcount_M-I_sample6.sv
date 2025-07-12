module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (shift_ena | count_ena) begin
            q <= shift_ena ? {q[2:0], data} : (q - 1);
        end
        // else hold state (no else needed as q is reg)
    end

endmodule