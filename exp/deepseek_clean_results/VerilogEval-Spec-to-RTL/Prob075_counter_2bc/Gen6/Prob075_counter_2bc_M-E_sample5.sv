module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// LUT-based state transition
reg [1:0] state_lut [0:15];  // 4-bit address space

// Initialize LUT (synthesizer will optimize this to minimal logic)
integer i;
initial begin
    for (i = 0; i < 16; i = i + 1) begin
        case (i[3:2])  // {train_valid, train_taken}
            2'b00: state_lut[i] = i[1:0];  // hold state
            2'b01: state_lut[i] = (i[1:0] == 2'b00) ? 2'b00 : (i[1:0] - 1);  // decrement with sat
            2'b10: state_lut[i] = (i[1:0] == 2'b11) ? 2'b11 : (i[1:0] + 1);  // increment with sat
            2'b11: state_lut[i] = i[1:0];  // invalid case (train_valid=1 and train_taken=1 same as 2'b10)
        endcase
    end
end

// Next state calculation
wire [1:0] next_state = areset ? 2'b01 : state_lut[{train_valid, train_taken, state}];

// State register
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01;
    else
        state <= next_state;
end

endmodule