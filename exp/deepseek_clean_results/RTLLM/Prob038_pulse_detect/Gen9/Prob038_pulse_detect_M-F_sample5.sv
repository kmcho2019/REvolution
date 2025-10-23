module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// State encoding
localparam [1:0] IDLE   = 2'b00;
localparam [1:0] GOT_0  = 2'b01;
localparam [1:0] GOT_01 = 2'b10;

reg [1:0] current_state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        data_out <= 1'b0;
    end else begin
        current_state <= next_state;
        
        // Output is only high when we complete the sequence
        data_out <= (current_state == GOT_01) && (data_in == 1'b0);
    end
end

always @(*) begin
    case (current_state)
        IDLE:   next_state = (data_in == 1'b0) ? GOT_0 : IDLE;
        GOT_0:  next_state = (data_in == 1'b1) ? GOT_01 : GOT_0;
        GOT_01: next_state = (data_in == 1'b0) ? IDLE : GOT_01;
        default: next_state = IDLE;
    endcase
end

endmodule