module TopModule (
    input clk,
    input d,
    output q
);

    reg q_posedge;
    reg q_negedge;

    // Sample d on posedge clk
    always @(posedge clk) begin
        q_posedge <= d;
    end

    // Sample d on negedge clk using posedge of inverted clk
    // clk_n is inverted clock
    wire clk_n = ~clk;

    always @(posedge clk_n) begin
        q_negedge <= d;
    end

    // Output q is mux between q_posedge and q_negedge based on clk level
    assign q = clk ? q_posedge : q_negedge;

endmodule