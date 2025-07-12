module TopModule (
    input clk,
    input d,
    output reg q
);

    // Sample d at posedge clk
    reg d_pos;
    always @(posedge clk) begin
        d_pos <= d;
    end

    // Sample d at posedge inverted clk (i.e., negedge clk)
    reg d_neg;
    wire clk_n = ~clk;
    always @(posedge clk_n) begin
        d_neg <= d;
    end

    // Toggle flip-flop clocked at posedge clk to select output source
    reg toggle;
    always @(posedge clk) begin
        toggle <= ~toggle;
    end

    // Output mux controlled by toggle flip-flop
    always @(*) begin
        if (toggle)
            q = d_pos;
        else
            q = d_neg;
    end

endmodule