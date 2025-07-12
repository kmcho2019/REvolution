module TopModule (
    input clk,
    input d,
    output q
);

    // Internal latch states
    reg master_latch;
    reg slave_latch;

    // Master latch - transparent when clk is low
    always @(clk or d) begin
        if (~clk) begin
            master_latch <= d;
        end
    end

    // Slave latch - transparent when clk is high
    always @(clk or master_latch) begin
        if (clk) begin
            slave_latch <= master_latch;
        end
    end

    // Output follows slave latch
    assign q = slave_latch;

endmodule