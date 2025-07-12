module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

parameter MAX_VALUE = 31;

reg [4:0] counter;
reg direction;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        direction <= 1;
    end else begin
        if (direction) begin
            if (counter == MAX_VALUE) begin
                counter <= counter - 1;
                direction <= 0;
            end else begin
                counter <= counter + 1;
            end
        end else begin
            if (counter == 0) begin
                counter <= counter + 1;
                direction <= 1;
            end else begin
                counter <= counter - 1;
            end
        end
    end
end

assign wave = counter;

endmodule