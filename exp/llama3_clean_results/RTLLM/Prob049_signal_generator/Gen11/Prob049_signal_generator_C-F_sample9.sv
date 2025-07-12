module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

parameter MAX_VALUE = 5'd31;

reg [4:0] counter;
reg direction; // 0: incrementing, 1: decrementing

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 5'd0;
        direction <= 1'b0;
    end else begin
        if (direction == 1'b0) begin
            counter <= (counter == MAX_VALUE) ? MAX_VALUE : counter + 1'd1;
            direction <= (counter == MAX_VALUE) ? 1'b1 : 1'b0;
        end else begin
            counter <= (counter == 5'd0) ? 5'd0 : counter - 1'd1;
            direction <= (counter == 5'd0) ? 1'b0 : 1'b1;
        end
    end
end

assign wave = counter;

endmodule