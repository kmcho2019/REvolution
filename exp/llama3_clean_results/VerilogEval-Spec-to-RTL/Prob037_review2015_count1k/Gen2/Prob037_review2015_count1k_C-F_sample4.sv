module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] count;

always @(posedge clk) begin
    if (reset) begin
        // Immediate reset when reset signal is high
        count <= 10'd0;
    end else begin
        // Count logic: increment or reset to 0 when reaching 999
        if (count == 10'd999) begin
            count <= 10'd0;
        end else begin
            count <= count + 10'd1;
        end
    end
end

assign q = count;

endmodule