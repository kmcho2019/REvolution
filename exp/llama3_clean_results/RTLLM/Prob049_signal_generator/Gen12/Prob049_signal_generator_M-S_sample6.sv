module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;
reg direction;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        direction <= 1; // default direction: increment
    end else begin
        if (direction) begin
            counter <= (counter == 31) ? 0 : counter + 1;
            if (counter == 31) direction <= 0; // change direction to decrement
        end else begin
            counter <= (counter == 0) ? 31 : counter - 1;
            if (counter == 0) direction <= 1; // change direction to increment
        end
    end
end

assign wave = counter;

endmodule