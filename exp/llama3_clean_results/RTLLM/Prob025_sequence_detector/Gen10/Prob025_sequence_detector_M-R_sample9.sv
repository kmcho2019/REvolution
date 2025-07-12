module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

reg [1:0] state;
reg [1:0] next_state;

localparam IDLE = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;
localparam S3 = 2'b11;

// Combinational logic to determine the next state
always @(*) begin
    case (state)
        IDLE: 
            next_state = (data_in == 1'b1) ? S1 : IDLE;
        S1: 
            next_state = (data_in == 1'b0) ? S2 : IDLE;
        S2: 
            next_state = (data_in == 1'b0) ? S3 : IDLE;
        S3: 
            next_state = (data_in == 1'b1) ? IDLE : IDLE;
        default: next_state = IDLE;
    endcase
end

// Sequential logic to update the state and sequence_detected signal
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= IDLE;
        sequence_detected <= 0;
    end else begin
        state <= next_state;
        sequence_detected <= (state == S3 && data_in == 1'b1) ? 1'b1 : 0;
    end
end

endmodule