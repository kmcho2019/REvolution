module TopModule(
    output reg zero,
    input clk,
    input rst_n
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            zero <= 1'b0;
        else
            zero <= 1'b0; // Always hold zero after reset
    end
endmodule