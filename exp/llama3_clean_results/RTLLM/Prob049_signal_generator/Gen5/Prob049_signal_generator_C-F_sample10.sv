module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;
reg dir;  // 1 for increment, 0 for decrement

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 5'd0;
        dir <= 1'b1;
        wave <= 5'd0;
    end else begin
        if (dir) begin
            if (counter == 5'd31) begin
                counter <= 5'd31;
                dir <= 1'b0;
            end else begin
                counter <= counter + 5'd1;
            end
        end else begin
            if (counter == 5'd0) begin
                counter <= 5'd0;
                dir <= 1'b1;
            end else begin
                counter <= counter - 5'd1;
            end
        end
    end
    wave <= counter;
end

endmodule