module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;
    end
    else if (train_valid) begin
        case ({train_taken, state})
            3'b1_11: state <= 2'b11;  // saturate at max when incrementing
            3'b1_00,
            3'b1_01,
            3'b1_10: state <= state + 1;  // increment otherwise
            
            3'b0_00: state <= 2'b00;  // saturate at min when decrementing
            3'b0_01,
            3'b0_10,
            3'b0_11: state <= state - 1;  // decrement otherwise
        endcase
    end
    // else hold state (implicit)
end

endmodule