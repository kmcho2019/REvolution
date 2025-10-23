module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);

    reg q_posedge, q_negedge;

    // Capture input on rising edge
    always @(posedge clk) begin
        q_posedge <= d;
    end

    // Capture input on falling edge
    always @(negedge clk) begin
        q_negedge <= d;
    end

    // Output selects based on clock level
    assign q = clk ? q_posedge : q_negedge;

endmodule