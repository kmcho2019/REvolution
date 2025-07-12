module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

// Define states
localparam IDLE    = 2'b00;
localparam GOT_0   = 2'b01;
localparam GOT_1   = 2'b10;

reg [1:0] state, next_state;

// State register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE:  next_state = (data_in == 0) ? GOT_0 : IDLE;
        GOT_0: next_state = (data_in == 1) ? GOT_1 : GOT_0;
        GOT_1: next_state = (data_in == 0) ? IDLE : GOT_1;
        default: next_state = IDLE;
    endcase
end

// Output logic - asserted only at end of complete pulse
assign data_out = (state == GOT_1 && data_in == 0);

endmodule