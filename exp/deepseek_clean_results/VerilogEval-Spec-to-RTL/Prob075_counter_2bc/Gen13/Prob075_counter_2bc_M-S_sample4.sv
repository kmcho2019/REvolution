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
    end
    else if (train_valid) begin
        case (state)
            2'b00: state <= train_taken ? 2'b01 : 2'b00;  // S0
            2'b01: state <= train_taken ? 2'b10 : 2'b00;  // S1
            2'b10: state <= train_taken ? 2'b11 : 2'b01;  // S2
            2'b11: state <= train_taken ? 2'b11 : 2'b10;  // S3
        endcase
    end
    // else state remains unchanged
end

endmodule