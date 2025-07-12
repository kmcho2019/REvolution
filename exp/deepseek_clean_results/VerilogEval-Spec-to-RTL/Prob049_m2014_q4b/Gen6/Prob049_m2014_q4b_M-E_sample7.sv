module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

// Master and slave latch outputs
reg master_latch;
reg slave_latch;

// Asynchronous reset has priority
always @(*) begin
    if (ar) begin
        master_latch = 1'b0;
        slave_latch = 1'b0;
    end
end

// Master latch (transparent when clk is low)
always @(negedge clk or posedge ar) begin
    if (!ar) begin
        master_latch <= d;
    end
end

// Slave latch (transparent when clk is high)
always @(posedge clk or posedge ar) begin
    if (!ar) begin
        slave_latch <= master_latch;
    end
end

assign q = slave_latch;

endmodule