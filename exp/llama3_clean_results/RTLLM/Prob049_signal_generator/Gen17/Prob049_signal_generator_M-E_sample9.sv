module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;
reg dir;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        dir <= 0;
    end else begin
        if (counter == 31) begin
            dir <= 1;
        end else if (counter == 0) begin
            dir <= 0;
        end

        if (dir == 0) begin
            counter <= counter + 1;
        end else begin
            counter <= counter - 1;
        end
    end
end

assign wave = counter;

endmodule