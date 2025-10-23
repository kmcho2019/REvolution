module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

// Binary state encoding
localparam IDLE  = 2'b00;
localparam GOT_0 = 2'b01;
localparam GOT_1 = 2'b10;

reg [1:0] state;

// State transition and output logic
always @(posedge clk) begin
    if (!rst_n) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE:  state <= (data_in == 0) ? GOT_0 : IDLE;
            GOT_0: state <= (data_in == 1) ? GOT_1 : (data_in == 0) ? GOT_0 : IDLE;
            GOT_1: state <= (data_in == 0) ? IDLE  : GOT_1;
            default: state <= IDLE;
        endcase
    end
end

// Output is high when in GOT_1 state and input is 0
assign data_out = (state == GOT_1) && (data_in == 0);

endmodule