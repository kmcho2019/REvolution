module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

reg [1:0] next_state;

always @(*) begin
    if (areset) begin
        next_state = 2'b01;
    end
    else if (train_valid) begin
        case ({train_taken, state})
            3'b100: next_state = 2'b00;  // decrement from 0 stays 0
            3'b101: next_state = 2'b00;  // decrement from 1
            3'b110: next_state = 2'b01;  // decrement from 2
            3'b111: next_state = 2'b10;  // decrement from 3
            3'b000: next_state = 2'b01;  // increment from 0
            3'b001: next_state = 2'b10;  // increment from 1
            3'b010: next_state = 2'b11;  // increment from 2
            3'b011: next_state = 2'b11;  // increment from 3 stays 3
            default: next_state = state;
        endcase
    end
    else begin
        next_state = state;
    end
end

always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01;
    else
        state <= next_state;
end

endmodule