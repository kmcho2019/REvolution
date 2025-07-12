module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

reg [4:0] ctr;

always @(posedge clk) begin
    if (reset) begin
        p <= 0;
        ctr <= 0;
        rdy <= 0;
    end else begin
        if (ctr < 8) begin
            if (b[ctr] == 1'b1) begin
                p <= p + { {8{a[7]}}, a } << ctr;
            end
            ctr <= ctr + 1;
        end else begin
            rdy <= 1;
        end
    end
end

endmodule