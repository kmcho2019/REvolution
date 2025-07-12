module counter_12 (
    input   rst_n,
    input   clk,
    input   valid_count,
    output reg [3:0] out
);

parameter MAX_COUNT = 4'd11;
parameter COUNTER_WIDTH = 4;

reg [COUNTER_WIDTH-1:0] counter;
reg counting;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 4'b0000;
        counting <= 1'b0;
    end else begin
        if (valid_count &&!counting) begin
            counting <= 1'b1;
        end else if (!valid_count && counting) begin
            counting <= 1'b0;
        end
        
        if (counting) begin
            if (counter == MAX_COUNT) begin
                counter <= 4'b0000;
            end else begin
                counter <= counter + 1;
            end
        end
    end
end

assign out = counter;

endmodule