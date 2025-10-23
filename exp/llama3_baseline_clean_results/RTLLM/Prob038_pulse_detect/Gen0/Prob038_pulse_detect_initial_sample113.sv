module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

// Declare the state register
reg [1:0] state;

// Declare the output register
reg data_out_reg;

// Assign the output
assign data_out = data_out_reg;

// Always block for state machine
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: set state to idle and data_out to 0
        state <= 2'b00;
        data_out_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin
                // Idle state: check for rising edge
                if (data_in) begin
                    state <= 2'b01;
                end
                data_out_reg <= 1'b0;
            end
            2'b01: begin
                // Rising state: check for falling edge
                if (~data_in) begin
                    state <= 2'b10;
                end
                data_out_reg <= 1'b0;
            end
            2'b10: begin
                // Falling state: set data_out to 1 and transition to idle
                state <= 2'b00;
                data_out_reg <= 1'b1;
            end
            default: begin
                state <= 2'b00;
                data_out_reg <= 1'b0;
            end
        endcase
    end
end

endmodule