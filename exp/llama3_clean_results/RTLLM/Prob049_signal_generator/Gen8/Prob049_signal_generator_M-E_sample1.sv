module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
    end else begin
        counter <= counter + 1;
    end
end

always @(*) begin
    if (counter < 16) begin
        wave = counter;
    end else begin
        wave = 31 - counter;
    end
end

endmodule