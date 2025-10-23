module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg invert_flag;  // 0 = copy, 1 = invert

    // Combinational output logic
    assign z = invert_flag ? ~x : x;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            invert_flag <= 1'b0;
        end else if (!invert_flag && x) begin
            invert_flag <= 1'b1;
        end
    end

endmodule