module width_8to16(
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg [1:0] state;  // State machine states: 2'b00 - WAIT_FOR_FIRST_BYTE, 2'b01 - WAIT_FOR_SECOND_BYTE
reg [15:0] buffer;  // Temporary buffer to store the input data
reg        valid_out_reg;  // Output valid signal register
reg [15:0] data_out_reg;  // 16-bit output data register

// State machine and output generation logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00;  // Reset state machine to WAIT_FOR_FIRST_BYTE
        buffer <= 16'd0;  // Reset buffer
        valid_out_reg <= 1'b0;  // Reset output valid signal
        data_out_reg <= 16'd0;  // Reset output data
    end else begin
        case (state)
            2'b00: begin  // WAIT_FOR_FIRST_BYTE
                if (valid_in) begin
                    buffer[15:8] <= data_in;  // Store first byte in higher 8 bits of buffer
                    state <= 2'b01;  // Transition to WAIT_FOR_SECOND_BYTE
                end
            end
            2'b01: begin  // WAIT_FOR_SECOND_BYTE
                if (valid_in) begin
                    buffer[7:0] <= data_in;  // Store second byte in lower 8 bits of buffer
                    data_out_reg <= buffer;  // Generate output by concatenating higher and lower 8 bits of buffer
                    valid_out_reg <= 1'b1;  // Set output valid signal
                    state <= 2'b00;  // Reset state machine to WAIT_FOR_FIRST_BYTE
                end
            end
            default: begin
                state <= 2'b00;  // Reset state machine to WAIT_FOR_FIRST_BYTE
            end
        endcase

        if (state == 2'b00 && !valid_in) begin
            valid_out_reg <= 1'b0;  // Reset output valid signal when not in WAIT_FOR_SECOND_BYTE state
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule