module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

parameter MAX_COUNT = 4'd11;
reg gated_clk;

// Clock gating logic
always @(*) begin
    gated_clk = clk & (valid_count | ~rst_n);
end

// Counter logic
always @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end
    else begin
        case (out)
            MAX_COUNT: out <= 4'b0000;
            default:   out <= out + 1'b1;
        endcase
    end
end

endmodule