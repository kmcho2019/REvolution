module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Reset to weakly not-taken
    end else if (train_valid) begin
        // Arithmetic implementation with saturation
        if (train_taken) begin
            state <= (state == 2'b11) ? 2'b11 : state + 1'b1;
        end else begin
            state <= (state == 2'b00) ? 2'b00 : state - 1'b1;
        end
    end
    // Implicit else: state remains unchanged when train_valid=0
end

endmodule