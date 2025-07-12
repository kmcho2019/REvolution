module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;
reg dir;  // 1 for increment, 0 for decrement

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        dir <= 1'b1;
    end else begin
        if (dir) begin
            if (counter == 31) begin
                dir <= 1'b0;
            end else begin
                counter <= counter + 1'b1;
            end
        end else begin
            if (counter == 0) begin
                dir <= 1'b1;
            end else begin
                counter <= counter - 1'b1;
            end
        end
    end
end

assign wave = counter;

endmodule