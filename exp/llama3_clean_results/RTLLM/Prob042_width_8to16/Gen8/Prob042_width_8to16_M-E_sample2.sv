module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg [1:0] state; // State machine with two states: idle (0) and wait_for_second_byte (1)
reg [7:0] first_byte; // Register to store the first 8-bit data input

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'd0; // Initialize state to idle
        first_byte <= 8'd0; // Initialize first_byte to 0
    end
    else begin
        case (state)
            2'd0: // idle state
                if (valid_in) begin
                    first_byte <= data_in; // Store the first 8-bit data input
                    state <= 2'd1; // Transition to wait_for_second_byte state
                end
            2'd1: // wait_for_second_byte state
                if (valid_in) begin
                    state <= 2'd0; // Transition back to idle state
                end
        endcase
    end
end

assign valid_out = (state == 2'd1 && valid_in); // Assert valid_out when in wait_for_second_byte state and valid_in is 1
assign data_out = (valid_out) ? {first_byte, data_in} : 16'd0; // Concatenate first_byte and data_in when valid_out is 1

endmodule