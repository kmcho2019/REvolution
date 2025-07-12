module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit register to keep track of the current state
reg prev_data_in; // Register to keep track of the previous state of data_in

localparam IDLE = 2'b00; // Initial state
localparam PULSE = 2'b01; // State when data_in rises
localparam FALLING = 2'b10; // State after data_in falls

always @(posedge clk) begin
    if (~rst_n) begin // Reset condition
        state <= IDLE;
        prev_data_in <= 0;
        data_out <= 0;
    end else begin
        prev_data_in <= data_in;
        
        case (state)
            IDLE: begin
                if (data_in && !prev_data_in) begin // data_in rises
                    state <= PULSE;
                end
                data_out <= 0;
            end
            PULSE: begin
                if (!data_in && prev_data_in) begin // data_in falls
                    state <= FALLING;
                end
                data_out <= 0;
            end
            FALLING: begin
                state <= IDLE;
                data_out <= 1; // Set data_out to 1 to indicate pulse
            end
        endcase
    end
end

endmodule