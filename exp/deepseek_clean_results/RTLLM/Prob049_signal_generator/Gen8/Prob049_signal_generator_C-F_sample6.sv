module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0=up, 1=down
reg [4:0] counter;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 5'b0;
        direction <= 1'b0;
    end
    else begin
        if (direction) begin
            counter <= counter - 1;
            if (counter == 5'b00001) direction <= 1'b0;
        end
        else begin
            counter <= counter + 1;
            if (counter == 5'b11110) direction <= 1'b1;
        end
    end
end

always @(posedge clk) begin
    wave <= counter;
end

endmodule