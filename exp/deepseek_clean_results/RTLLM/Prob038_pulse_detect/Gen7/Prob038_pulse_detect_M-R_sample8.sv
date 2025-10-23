module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// One-hot state encoding
localparam [3:0] 
    IDLE   = 4'b0001,
    GOT_0  = 4'b0010,
    GOT_01 = 4'b0100,
    PULSE  = 4'b1000;

reg [3:0] state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE:   state <= (data_in == 0) ? GOT_0 : IDLE;
            GOT_0:  state <= (data_in == 1) ? GOT_01 : GOT_0;
            GOT_01: state <= (data_in == 0) ? PULSE : IDLE;
            PULSE:  state <= (data_in == 0) ? GOT_0 : IDLE;
            default: state <= IDLE;
        endcase
    end
end

// Output is high only in PULSE state
assign data_out = (state == PULSE);

endmodule