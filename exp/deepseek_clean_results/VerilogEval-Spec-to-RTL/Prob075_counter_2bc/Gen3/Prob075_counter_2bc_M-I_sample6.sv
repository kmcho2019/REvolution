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
            counter <= 2'b01;  // Reset to weakly not-taken
        end else if (train_valid) begin
            // Arithmetic approach with saturation checks
            if (train_taken) begin
                counter <= (counter == 2'b11) ? 2'b11 : counter + 1;
            end else begin
                counter <= (counter == 2'b00) ? 2'b00 : counter - 1;
            end
        end
    end

    assign state = counter;

endmodule