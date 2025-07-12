module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output sequence_detected
);

// State encoding (one-hot)
localparam IDLE = 1'b0;
localparam WAIT_FOR_LAST_1 = 1'b1;

reg [2:0] shift_reg;
reg state;
wire next_state;

// Shift register logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 3'b0;
    end
    else begin
        shift_reg <= {shift_reg[1:0], data_in};
    end
end

// State transition logic
assign next_state = (state == IDLE) ? 
                   ((shift_reg[1:0] == 2'b10 && data_in == 1'b0) ? WAIT_FOR_LAST_1 : IDLE) :
                   IDLE;

// State register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end
    else begin
        state <= next_state;
    end
end

// Output logic (combinational)
assign sequence_detected = (state == WAIT_FOR_LAST_1) && data_in && (shift_reg == 3'b100);

endmodule