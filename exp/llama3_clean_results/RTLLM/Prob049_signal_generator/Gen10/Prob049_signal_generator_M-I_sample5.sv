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
        if (counter == 31) begin
            counter <= counter - 1;
        end else if (counter == 0) begin
            counter <= counter + 1;
        end else begin
            counter <= (counter < 16) ? counter + 1 : counter - 1;
        end
    end
end

assign wave = counter;

endmodule