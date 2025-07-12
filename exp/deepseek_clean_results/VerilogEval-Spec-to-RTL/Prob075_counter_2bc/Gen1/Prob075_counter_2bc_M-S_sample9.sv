module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

    reg [1:0] counter;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            counter <= 2'b01;
        end else if (train_valid) begin
            counter <= train_taken ? (counter | (counter + 1)) : (counter & (counter - 1));
        end
    end

    assign state = counter;

endmodule