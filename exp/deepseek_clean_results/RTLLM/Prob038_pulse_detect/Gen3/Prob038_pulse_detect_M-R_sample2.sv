module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

// State definitions
localparam IDLE   = 2'b00;
localparam GOT_0  = 2'b01;
localparam GOT_01 = 2'b10;
localparam PULSE  = 2'b11;

reg [1:0] state, next_state;

// Continuous output assignment
assign data_out = (state == PULSE);

// State transition logic
always @(*) begin
    case (state)
        IDLE:   next_state = (data_in == 0) ? GOT_0 : IDLE;
        GOT_0:  next_state = (data_in == 1) ? GOT_01 : GOT_0;
        GOT_01: next_state = (data_in == 0) ? PULSE : IDLE;
        PULSE:  next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

// State register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

endmodule