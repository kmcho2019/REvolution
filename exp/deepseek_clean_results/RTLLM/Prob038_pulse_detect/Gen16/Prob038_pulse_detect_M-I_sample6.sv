module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

// State encoding
localparam IDLE   = 1'b0;
localparam GOT_01 = 1'b1;

reg state;
wire next_state;
wire pulse_detected;

// Next state logic
assign next_state = (state == IDLE) ? 
                   (data_in ? IDLE : GOT_01) :  // If in IDLE, stay or move to GOT_01
                   (data_in ? IDLE : GOT_01);   // If in GOT_01, complete pulse or stay

// Output is high when we detect the final 0 in the sequence
assign pulse_detected = (state == GOT_01) && !data_in;
assign data_out = pulse_detected;

// State register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end
    else begin
        state <= next_state;
    end
end

endmodule