module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [5:0] counter;  // Internal 6-bit counter

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 6'b0;
    end
    else begin
        counter <= counter + 1;
    end
end

// Output generation - creates triangle wave from counter
always @(*) begin
    wave = counter[5] ? ~counter[4:0] : counter[4:0];
end

endmodule