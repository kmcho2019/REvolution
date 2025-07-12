module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// synopsys translate_off
// Enable power optimization through clock gating
// synopsys translate_on

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end
    else begin
        Q <= {~Q[0], Q[63:1]};
    end
end

endmodule