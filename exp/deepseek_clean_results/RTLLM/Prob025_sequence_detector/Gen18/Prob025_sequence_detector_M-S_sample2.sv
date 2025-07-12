module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// State encoding
localparam IDLE   = 2'b00;
localparam GOT1   = 2'b01;
localparam GOT10  = 2'b10;
localparam GOT100 = 2'b11;

reg [1:0] state, next_state;

// State transition logic
always @(*) begin
    case (state)
        IDLE:   next_state = data_in ? GOT1 : IDLE;
        GOT1:   next_state = data_in ? GOT1 : GOT10;
        GOT10:  next_state = data_in ? GOT1 : GOT100;
        GOT100: next_state = data_in ? GOT1 : IDLE;
        default: next_state = IDLE;
    endcase
end

// Output and state update
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= IDLE;
        sequence_detected <= 1'b0;
    end
    else begin
        state <= next_state;
        sequence_detected <= (state == GOT100) & data_in;
    end
end

endmodule