module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 = up, 1 = down
reg [4:0] up_counter;
reg [4:0] down_counter;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        up_counter <= 5'b0;
        down_counter <= 5'b11111;
        direction <= 1'b0;
        wave <= 5'b0;
    end else begin
        // Update up counter
        if (~direction) begin
            up_counter <= (up_counter == 5'b11111) ? up_counter : up_counter + 1;
        end

        // Update down counter
        if (direction) begin
            down_counter <= (down_counter == 5'b00000) ? down_counter : down_counter - 1;
        end

        // Update direction and select output
        if (~direction && (up_counter == 5'b11111)) begin
            direction <= 1'b1;
            wave <= up_counter;
        end else if (direction && (down_counter == 5'b00000)) begin
            direction <= 1'b0;
            wave <= down_counter;
        end else begin
            wave <= direction ? down_counter : up_counter;
        end
    end
end

endmodule