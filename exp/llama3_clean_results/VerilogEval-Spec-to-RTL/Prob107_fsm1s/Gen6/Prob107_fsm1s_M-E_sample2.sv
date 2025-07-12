module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

reg state; // using a single bit for two states
parameter B = 1'b1;
parameter A = 1'b0;

// Define the lookup table for next state and output
wire [1:0] lut_out;
wire [1:0] lut_next_state;

// The LUT is essentially a 2x2 table where each row represents a current state
// and each column represents an input value. The values in the table are the next state and output.
assign lut_out = (state == B && in == 1'b0) ? 2'b01 :
                 (state == B && in == 1'b1) ? 2'b11 :
                 (state == A && in == 1'b0) ? 2'b10 :
                 (state == A && in == 1'b1) ? 2'b00;

assign lut_next_state = lut_out[1];
assign out = lut_out[0];

// State register with reset
always @(posedge clk) begin
    if(reset) begin
        state <= B;
    end else begin
        state <= lut_next_state;
    end
end

endmodule