module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

reg master_latch;

always @(posedge clk or posedge ar) begin
    if (ar) begin
        master_latch <= 1'b0; // Asynchronous reset
        q <= 1'b0; // Asynchronous reset
    end else if (clk) begin
        master_latch <= d; // Capture input data on rising edge of clock
    end
end

always @(negedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0; // Asynchronous reset
    end else if (!clk) begin
        q <= master_latch; // Transfer data from master latch to output on falling edge of clock
    end
end

endmodule