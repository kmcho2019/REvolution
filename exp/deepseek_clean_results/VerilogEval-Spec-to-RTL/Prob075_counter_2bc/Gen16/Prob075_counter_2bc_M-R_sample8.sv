module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// State register with Gray coding (00, 01, 11, 10)
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Weakly not-taken (reset state)
    end
    else if (train_valid) begin
        case (state)
            2'b00: state <= train_taken ? 2'b01 : 2'b00;  // S0: Strongly not-taken
            2'b01: state <= train_taken ? 2'b11 : 2'b00;  // S1: Weakly not-taken
            2'b11: state <= train_taken ? 2'b10 : 2'b01;  // S2: Weakly taken
            2'b10: state <= train_taken ? 2'b10 : 2'b11;  // S3: Strongly taken
            default: state <= 2'b01;
        endcase
    end
end

endmodule