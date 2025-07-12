module right_shifter(
    input clk,
    input d,
    output reg [7:0] q
);

    initial begin
        q = 0;
    end

    reg [7:0] temp_q;

    always @(posedge clk) begin
        temp_q = {d, q[7:1]};
        q <= temp_q;
    end

endmodule