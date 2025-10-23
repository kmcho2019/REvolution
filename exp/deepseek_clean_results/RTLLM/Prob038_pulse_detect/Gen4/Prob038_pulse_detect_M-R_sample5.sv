module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

// State encoding
localparam IDLE   = 2'b00;
localparam GOT_0  = 2'b01;
localparam GOT_01 = 2'b10;

reg [1:0] current_state, next_state;

// Next state logic (combinational)
always @(*) begin
    case (current_state)
        IDLE:   next_state = (data_in == 1'b0) ? GOT_0 : IDLE;
        GOT_0:  next_state = (data_in == 1'b1) ? GOT_01 : GOT_0;
        GOT_01: next_state = (data_in == 1'b0) ? IDLE : GOT_0;
        default: next_state = IDLE;
    endcase
end

// State storage (sequential)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Output logic (combinational)
assign data_out = (current_state == GOT_01) && (data_in == 1'b0);

endmodule