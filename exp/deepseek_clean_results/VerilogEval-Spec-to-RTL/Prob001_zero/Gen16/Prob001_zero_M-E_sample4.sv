module TopModule (
    output reg zero,
    input clk,
    input reset
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            zero <= 1'b0;
        end else begin
            zero <= zero + 1'b0;  // This will always maintain zero
        end
    end
endmodule