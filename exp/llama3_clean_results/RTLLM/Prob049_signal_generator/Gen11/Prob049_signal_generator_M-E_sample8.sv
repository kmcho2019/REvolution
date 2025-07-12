module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] lut [31:0];
reg [4:0] counter;
reg dir;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        dir <= 0;
    end else begin
        if (dir == 0) begin
            counter <= (counter == 31)? 31 : counter + 1;
            if (counter == 31) dir <= 1;
        end else begin
            counter <= (counter == 0)? 0 : counter - 1;
            if (counter == 0) dir <= 0;
        end
    end
end

integer i;
initial begin
    for (i = 0; i <= 31; i++) begin
        lut[i] = i;
    end
    for (i = 32; i <= 63; i++) begin
        lut[i-32] = 31 - (i-32);
    end
end

always @(posedge clk) begin
    wave <= lut[counter];
end

endmodule