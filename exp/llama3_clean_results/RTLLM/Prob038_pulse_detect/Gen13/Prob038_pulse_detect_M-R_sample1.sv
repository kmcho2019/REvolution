module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // Register to store the current state

// Combinational logic to determine next state and output value
wire pulse_detect;
wire [1:0] next_state;

assign pulse_detect = (state == 2'b10) & ~data_in;
assign next_state = (state == 2'b00 & data_in) ? 2'b01 :
                     (state == 2'b01 & data_in) ? 2'b01 :
                     (state == 2'b01 & ~data_in) ? 2'b10 :
                     (state == 2'b10) ? 2'b00 :
                     (state == 2'b00 & ~data_in) ? 2'b00 : 2'b00;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= 2'b00; // Initial state: idle
        data_out <= 1'b0;
    end else begin
        state <= next_state; // Update state
        data_out <= pulse_detect; // Update output
    end
end

endmodule