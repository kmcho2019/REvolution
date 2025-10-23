module TopModule(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

reg [1:0] counter;
reg [1:0] next_counter;

always @(*) begin
    if (areset) begin
        next_counter = 2'b01;
    end else if (train_valid) begin
        if (train_taken) begin
            next_counter = (counter == 2'b11) ? 2'b11 : counter + 1;
        end else begin
            next_counter = (counter == 2'b00) ? 2'b00 : counter - 1;
        end
    end else begin
        next_counter = counter;
    end
end

always @(posedge clk) begin
    counter <= next_counter;
end

assign state = counter;

endmodule