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
            3'b0_00: state <= 2'b00;  // Decrement saturate at 0
            3'b0_01: state <= 2'b00;
            3'b0_10: state <= 2'b01;
            3'b0_11: state <= 2'b10;
            3'b1_00: state <= 2'b01;  // Increment from 0
            3'b1_01: state <= 2'b10;
            3'b1_10: state <= 2'b11;
            3'b1_11: state <= 2'b11;  // Increment saturate at 3
        endcase
    end
end

endmodule