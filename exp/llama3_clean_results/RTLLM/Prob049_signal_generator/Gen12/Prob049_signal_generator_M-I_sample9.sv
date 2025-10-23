module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;
reg dir; // 0: incrementing, 1: decrementing

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        dir <= 0;
    end else begin
        counter <= (dir == 0) ? (counter == 31) ? 31 : counter + 1 : (counter == 0) ? 0 : counter - 1;
        if ((dir == 0 && counter == 31) || (dir == 1 && counter == 0)) begin
            dir <= ~dir;
        end
    end
end

assign wave = counter;

endmodule