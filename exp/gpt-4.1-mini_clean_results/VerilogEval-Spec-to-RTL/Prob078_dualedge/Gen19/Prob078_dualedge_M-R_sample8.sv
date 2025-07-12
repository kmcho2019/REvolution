module TopModule (
    input wire clk,
    input wire d,
    output wire q
);

    reg q_posedge_sample;
    reg q_negedge_sample;

    // Sample input d at positive clock edge
    always @(posedge clk) begin
        q_posedge_sample <= d;
    end

    // Sample input d at negative clock edge
    always @(negedge clk) begin
        q_negedge_sample <= d;
    end

    // Output selected based on clock level: high clk picks posedge sample, low clk picks negedge sample
    assign q = clk ? q_posedge_sample : q_negedge_sample;

endmodule