module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;
reg direction; // 0: incrementing, 1: decrementing

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        direction <= 0;
    end else begin
        if (direction == 0) begin
            if (counter == 31) begin
                counter <= 31;
                direction <= 1;
            end else begin
                counter <= counter + 1;
            end
        end else begin
            if (counter == 0) begin
                counter <= 0;
                direction <= 0;
            end else begin
                counter <= counter - 1;
            end
        end
    end
end

assign wave = counter;

endmodule