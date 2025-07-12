module TopModule (
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] counter;

always @(posedge areset or posedge clk) begin
    if (areset) begin
        counter <= 2'b01;
    end else if (train_valid) begin
        if (train_taken && counter < 3) begin
            counter <= counter + 1;
        end else if (!train_taken && counter > 0) begin
            counter <= counter - 1;
        end
    end
end

assign state = counter;

endmodule