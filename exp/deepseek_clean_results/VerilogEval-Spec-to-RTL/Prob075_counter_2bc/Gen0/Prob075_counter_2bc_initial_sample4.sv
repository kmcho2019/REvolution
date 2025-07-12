module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // reset to weakly not-taken
    end
    else begin
        if (train_valid) begin
            case ({train_taken, state})
                // Increment cases (train_taken=1)
                3'b100: state <= 2'b01;  // 0 -> 1
                3'b101: state <= 2'b10;  // 1 -> 2
                3'b110: state <= 2'b11;  // 2 -> 3
                3'b111: state <= 2'b11;  // 3 -> 3 (saturate)
                
                // Decrement cases (train_taken=0)
                3'b001: state <= 2'b00;  // 1 -> 0
                3'b010: state <= 2'b01;  // 2 -> 1
                3'b011: state <= 2'b10;  // 3 -> 2
                3'b000: state <= 2'b00;  // 0 -> 0 (saturate)
            endcase
        end
        // else maintain current state (implicit)
    end
end

endmodule