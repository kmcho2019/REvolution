module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

// Binary state encoding
localparam IDLE   = 2'b00;
localparam GOT_0  = 2'b01;
localparam GOT_01 = 2'b10;

reg [1:0] state;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE:   state <= (data_in == 0) ? GOT_0 : IDLE;
            GOT_0:  state <= (data_in == 1) ? GOT_01 : GOT_0;
            GOT_01: state <= (data_in == 0) ? IDLE : GOT_01;
            default: state <= IDLE;
        endcase
    end
end

// Output logic - pulse detected when we see 0 after 01
assign data_out = (state == GOT_01) && (data_in == 0);

endmodule