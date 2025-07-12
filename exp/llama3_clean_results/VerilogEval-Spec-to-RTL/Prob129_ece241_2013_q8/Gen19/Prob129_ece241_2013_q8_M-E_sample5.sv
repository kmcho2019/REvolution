module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg stage1, stage2;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        stage1 <= 1'b0;
        stage2 <= 1'b0;
    end else begin
        if (x == 1'b1) begin
            stage1 <= 1'b1;
        end else if (stage1 == 1'b1 && x == 1'b0) begin
            stage2 <= 1'b1;
        end else if (stage2 == 1'b1 && x == 1'b1) begin
            // Do nothing, output will be asserted
        end else begin
            stage1 <= 1'b0;
            stage2 <= 1'b0;
        end
    end
end

// Output logic
assign z = (stage2 == 1'b1) && (x == 1'b1);

endmodule