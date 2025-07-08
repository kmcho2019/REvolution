module TopModule(
    input clk,
    input d,
    output reg q
);

    reg q_posedge;
    reg q_negedge;

    // Capture d on positive edge
    always @(posedge clk) begin
        q_posedge <= d;
    end

    // Capture d on negative edge
    always @(negedge clk) begin
        q_negedge <= d;
    end

    // Output q updates on both edges using the stored values
    always @(posedge clk or negedge clk) begin
        // Use the value captured on the current edge
        if (clk)
            q <= q_posedge;
        else
            q <= q_negedge;
    end

endmodule