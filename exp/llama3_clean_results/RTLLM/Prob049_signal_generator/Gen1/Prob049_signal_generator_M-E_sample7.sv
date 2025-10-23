module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;
reg direction;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        direction <= 1; // 1 for increment, 0 for decrement
    end else begin
        if (direction) begin
            counter <= counter + 1;
            if (counter == 31) begin
                direction <= 0;
            end
        end else begin
            counter <= counter - 1;
            if (counter == 0) begin
                direction <= 1;
            end
        end
    end
end

assign wave = counter;

endmodule