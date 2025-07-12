module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

// One-hot encoded states
localparam IDLE = 2'b00;
localparam GOT1 = 2'b01;
localparam GOT10 = 2'b10;
localparam GOT100 = 2'b11;

reg [1:0] state, next_state;

// State transition logic with early termination
always @(*) begin
    case (state)
        IDLE: next_state = (data_in == 1'b1) ? GOT1 : IDLE;
        GOT1: next_state = (data_in == 1'b0) ? GOT10 : GOT1;
        GOT10: next_state = (data_in == 1'b0) ? GOT100 : IDLE;
        GOT100: next_state = (data_in == 1'b1) ? GOT1 : IDLE;
        default: next_state = IDLE;
    endcase
end

// Output and state register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        sequence_detected <= 1'b0;
    end
    else begin
        state <= next_state;
        // Detect when we transition to GOT100 and get a '1'
        sequence_detected <= (state == GOT100) && (data_in == 1'b1);
    end
end

endmodule