module TopModule (
    input wire clk,
    input wire d,
    output wire q
);

    reg q_posedge;
    reg q_negedge;

    // Sample d on positive edge
    always @(posedge clk) begin
        q_posedge <= d;
    end

    // Sample d on negative edge
    always @(negedge clk) begin
        q_negedge <= d;
    end

    // Output selects sampled value based on clock level
    assign q = clk ? q_posedge : q_negedge;

endmodule