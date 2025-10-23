module signal_generator (
    input clk,
    input rst_n,
    output [4:0] wave
);

reg [5:0] counter;  // Internal 6-bit counter (5-bit value + 1-bit direction)

// Counter logic - increments continuously, MSB becomes direction flag
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 6'b0;
    end else begin
        counter <= counter + 1;
    end
end

// Continuous assignment for wave generation
// When MSB=0 (counting up): output lower 5 bits directly
// When MSB=1 (counting down): output inverted lower 5 bits (equivalent to 31 - count)
assign wave = counter[5] ? ~counter[4:0] : counter[4:0];

endmodule