module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

localparam RESET_VALUE = 2'b01;  // Weakly not-taken

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= RESET_VALUE;
    end
    else if (train_valid) begin
        // Arithmetic approach with saturation
        if (train_taken) begin
            state <= (state == 2'b11) ? 2'b11 : (state + 1'b1);
        end
        else begin
            state <= (state == 2'b00) ? 2'b00 : (state - 1'b1);
        end
    end
    // else hold current value (implicit)
end

endmodule