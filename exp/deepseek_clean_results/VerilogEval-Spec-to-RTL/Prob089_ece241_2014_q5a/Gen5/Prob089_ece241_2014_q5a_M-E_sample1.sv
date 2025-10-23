module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg complement_flag;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            complement_flag <= 1'b0;
        end else begin
            // The flag stays set once it's triggered by first '1'
            complement_flag <= complement_flag | x;
        end
    end

    // Output is XOR of input with complement flag
    assign z = x ^ complement_flag;

endmodule