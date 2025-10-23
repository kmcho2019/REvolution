module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// State encoding
localparam IDLE = 2'b00;
localparam GOT1 = 2'b01;
localparam GOT10 = 2'b10;
localparam GOT100 = 2'b11;

reg [1:0] state, next_state;

// State transition logic
always @(*) begin
    case (state)
        IDLE: next_state = (data_in == 1'b1) ? GOT1 : IDLE;
        GOT1: next_state = (data_in == 1'b0) ? GOT10 : GOT1;
        GOT10: next_state = (data_in == 1'b0) ? GOT100 : GOT1;
        GOT100: next_state = (data_in == 1'b1) ? IDLE : GOT10;
        default: next_state = IDLE;
    endcase
end

// Output logic
always @(*) begin
    sequence_detected = (state == GOT100) && (data_in == 1'b1);
end

// State register
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

endmodule