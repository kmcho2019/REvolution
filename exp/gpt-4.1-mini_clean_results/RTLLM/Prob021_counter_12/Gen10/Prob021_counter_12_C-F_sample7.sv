module counter_12 #(
    parameter MAX_COUNT = 4'd11
)(
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else if (valid_count) begin
        if (out == MAX_COUNT)
            out <= 4'b0000;
        else
            out <= out + 1'b1;
    end
    // else: hold value, no redundant assignment to save power
end

endmodule