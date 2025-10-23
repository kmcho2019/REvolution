module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [1:0] cnt;

    always @(posedge clk) begin
        if (reset) cnt <= 2'b0;
        else cnt <= (cnt == 0) ? (in[3] ? 2'b01 : 2'b0) : (cnt + 1'b1);
    end

    assign done = (cnt == 2'b10);
endmodule