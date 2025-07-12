module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Binary state encoding
localparam [1:0] 
    IDLE   = 2'b00,
    GOT_0  = 2'b01,
    GOT_01 = 2'b10,
    PULSE  = 2'b11;

reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end else begin
        case (state)
            IDLE:   state <= (data_in == 0) ? GOT_0 : IDLE;
            GOT_0:  state <= (data_in == 1) ? GOT_01 : GOT_0;
            GOT_01: state <= (data_in == 0) ? PULSE : IDLE;
            PULSE:  state <= (data_in == 0) ? GOT_0 : IDLE;
            default: state <= IDLE;
        endcase
        
        // Registered output to prevent glitches
        data_out <= (state == GOT_01) && (data_in == 0);
    end
end

endmodule