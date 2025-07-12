module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output          sequence_detected
);

reg [1:0] state;
reg [1:0] next_state;

// Control logic
always_ff @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        state <= 2'b00;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (state)
        2'b00: next_state = (data_in == 1'b1) ? 2'b01 : 2'b00;
        2'b01: next_state = (data_in == 1'b0) ? 2'b10 : 2'b00;
        2'b10: next_state = (data_in == 1'b0) ? 2'b11 : 2'b00;
        2'b11: next_state = (data_in == 1'b1) ? 2'b11 : 2'b00;
        default: next_state = 2'b00;
    endcase
end

// Output logic
assign sequence_detected = (state == 2'b11);

endmodule