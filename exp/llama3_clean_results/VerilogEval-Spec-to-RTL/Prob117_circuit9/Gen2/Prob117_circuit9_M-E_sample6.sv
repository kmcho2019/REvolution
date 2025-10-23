module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] counter;
reg hold;

always @(posedge clk) begin
    if (~a) begin
        if (counter == 4) begin
            counter <= counter + 1;
            hold <= 1'b0;
        end else if (counter < 4) begin
            counter <= 4;
            hold <= 1'b0;
        end else if (counter == 7) begin
            counter <= 0;
            hold <= 1'b0;
        end else begin
            counter <= counter + 1;
            hold <= 1'b0;
        end
    end else begin
        hold <= 1'b1;
    end
end

always @(posedge clk) begin
    if (hold) begin
        // do nothing, hold the current counter value
    end
end

assign q = counter;

initial begin
    counter = 4; // Initialize q to 4 (100 in binary) on power-up
    hold = 1'b0;
end

endmodule