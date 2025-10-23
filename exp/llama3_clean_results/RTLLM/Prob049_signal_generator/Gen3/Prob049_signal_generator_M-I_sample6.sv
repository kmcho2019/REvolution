module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;
reg direction;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 5'd0;
        direction <= 1'b1; // 1 for increment, 0 for decrement
        wave <= 5'd0;
    end else begin
        if (direction) begin
            if (counter == 5'd31) begin
                counter <= 5'd31;
                direction <= 1'b0;
                wave <= 5'd31;
            end else begin
                counter <= counter + 5'd1;
                wave <= counter + 5'd1;
            end
        end else begin
            if (counter == 5'd0) begin
                counter <= 5'd0;
                direction <= 1'b1;
                wave <= 5'd0;
            end else begin
                counter <= counter - 5'd1;
                wave <= counter - 5'd1;
            end
        end
    end
end

endmodule