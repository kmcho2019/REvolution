module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

    reg load_enable;

    // Register the enable signal one clock cycle before loading q
    always @(posedge clk) begin
        load_enable <= (d != q);
    end

    // Load q with d when load_enable is asserted
    always @(posedge clk) begin
        if (load_enable)
            q <= d;
    end

    // Optional: initialize q to zero for simulation clarity
    // synthesis translate_off
    initial begin
        q = 8'b0;
        load_enable = 1'b0;
    end
    // synthesis translate_on

endmodule