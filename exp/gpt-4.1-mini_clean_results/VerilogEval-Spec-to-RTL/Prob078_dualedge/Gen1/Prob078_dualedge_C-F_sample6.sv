module TopModule(
    input clk,
    input d,
    output reg q
);

    reg q_posedge;
    reg q_negedge;
    reg q_mux;

    // Sample input on rising edge
    always @(posedge clk) begin
        q_posedge <= d;
    end

    // Sample input on falling edge
    always @(negedge clk) begin
        q_negedge <= d;
    end

    // Combinational mux selects between samples based on clock level
    always @(*) begin
        if (clk)
            q_mux = q_posedge;
        else
            q_mux = q_negedge;
    end

    // Register the mux output on rising edge to reduce glitches on q
    always @(posedge clk) begin
        q <= q_mux;
    end

endmodule