module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

parameter MAX_VALUE = 5'd31;

reg dir; // 0: incrementing, 1: decrementing
reg [4:0] counter;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        dir <= 0;
        counter <= 0;
    end else begin
        if (dir == 0) begin
            if (counter == MAX_VALUE) begin
                counter <= MAX_VALUE;
                dir <= 1;
            end else begin
                counter <= counter + 1;
            end
        end else begin
            if (counter == 0) begin
                counter <= 0;
                dir <= 0;
            end else begin
                counter <= counter - 1;
            end
        end
    end
end

assign wave = counter;

endmodule