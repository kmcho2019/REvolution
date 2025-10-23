module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;
reg [4:0] step;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        step <= 1;
    end else begin
        counter <= counter + step;
        if (counter == 31) begin
            step <= -1;
        end else if (counter == 0) begin
            step <= 1;
        end
    end
end

assign wave = counter;

endmodule