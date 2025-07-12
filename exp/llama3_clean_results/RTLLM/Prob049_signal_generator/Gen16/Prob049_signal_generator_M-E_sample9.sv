module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;
reg incrementing;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        incrementing <= 1;
    end else begin
        if (incrementing) begin
            counter <= (counter == 31) ? 31 : counter + 1;
            if (counter == 31) begin
                incrementing <= 0;
            end
        end else begin
            counter <= (counter == 0) ? 0 : counter - 1;
            if (counter == 0) begin
                incrementing <= 1;
            end
        end
    end
end

assign wave = counter;

endmodule