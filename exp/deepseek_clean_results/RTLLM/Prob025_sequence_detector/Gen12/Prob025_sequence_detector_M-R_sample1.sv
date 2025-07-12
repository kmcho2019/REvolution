module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

// State encoding (one-hot for clarity)
localparam IDLE         = 3'b001;
localparam PARTIAL_MATCH = 3'b010;
localparam FULL_MATCH    = 3'b100;

reg [2:0] current_state, next_state;
reg [2:0] shift_reg;

// Shift register update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        shift_reg <= 3'b0;
    else
        shift_reg <= {shift_reg[1:0], data_in};
end

// Next state logic (combinatorial)
assign next_state = (!rst_n) ? IDLE :
                   (current_state == IDLE && shift_reg[1:0] == 2'b10 && data_in == 1'b0) ? PARTIAL_MATCH :
                   (current_state == PARTIAL_MATCH && data_in) ? FULL_MATCH :
                   (current_state == PARTIAL_MATCH && shift_reg[1:0] == 2'b10 && data_in == 1'b0) ? PARTIAL_MATCH :
                   (current_state == FULL_MATCH) ? IDLE :
                   IDLE;

// State register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

// Output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        sequence_detected <= 1'b0;
    else
        sequence_detected <= (next_state == FULL_MATCH);
end

endmodule