module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg found;
    reg stage1;  // First '1' detected
    reg stage2;  // '11' detected
    reg stage3;  // '110' detected

    always @(posedge clk) begin
        if (reset) begin
            found <= 1'b0;
            stage1 <= 1'b0;
            stage2 <= 1'b0;
            stage3 <= 1'b0;
        end else if (!found) begin
            // Binary decision tree for pattern matching
            stage1 <= data;  // First bit must be 1
            stage2 <= stage1 && data;  // Second bit must be 1
            stage3 <= stage2 && ~data;  // Third bit must be 0
            found <= stage3 && data;    // Fourth bit must be 1
        end
    end

    assign start_shifting = found;

endmodule