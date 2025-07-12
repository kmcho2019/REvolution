module sequence_detector(
    input           clk,
    input           rst_n,
    input           data_in,
    output          sequence_detected
);

reg [1:0] state;
reg [1:0] next_state;

// State machine logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        2'b00: next_state = data_in ? 2'b01 : 2'b00;
        2'b01: next_state = data_in ? 2'b01 : 2'b10;
        2'b10: next_state = data_in ? 2'b00 : 2'b11;
        2'b11: next_state = data_in ? 2'b01 : 2'b00;
        default: next_state = 2'b00;
    endcase
end

// Output logic
assign sequence_detected = (state == 2'b11);

endmodule