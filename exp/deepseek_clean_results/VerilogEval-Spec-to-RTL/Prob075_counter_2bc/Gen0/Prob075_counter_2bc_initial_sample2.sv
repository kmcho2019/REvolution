module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Reset to weakly not-taken (01)
    end
    else begin
        if (train_valid) begin
            case ({train_taken, state})
                // Increment cases (when train_taken=1)
                2'b1_00: state <= 2'b01;
                2'b1_01: state <= 2'b10;
                2'b1_10: state <= 2'b11;
                2'b1_11: state <= 2'b11;  // Saturate at 3
                // Decrement cases (when train_taken=0)
                2'b0_00: state <= 2'b00;  // Saturate at 0
                2'b0_01: state <= 2'b00;
                2'b0_10: state <= 2'b01;
                2'b0_11: state <= 2'b10;
            endcase
        end
        // else: state remains unchanged (implicit)
    end
end

endmodule