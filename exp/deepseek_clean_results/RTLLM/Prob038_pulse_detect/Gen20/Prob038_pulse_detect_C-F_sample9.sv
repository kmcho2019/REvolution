module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

// State definitions
localparam IDLE  = 1'b0;
localparam GOT_1 = 1'b1;

reg state;      // Current state
reg prev_data;  // Previous data_in value

// State transition and storage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        prev_data <= 1'b0;
    end else begin
        prev_data <= data_in;
        case (state)
            IDLE:  state <= (prev_data == 1'b0 && data_in == 1'b1) ? GOT_1 : IDLE;
            GOT_1: state <= (data_in == 1'b1) ? IDLE : GOT_1;
        endcase
    end
end

// Output detects falling edge after GOT_1 state
assign data_out = (state == GOT_1) && (prev_data == 1'b1) && (data_in == 1'b0);

endmodule