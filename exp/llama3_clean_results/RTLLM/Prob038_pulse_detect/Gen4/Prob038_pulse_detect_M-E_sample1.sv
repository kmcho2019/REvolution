module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit register to keep track of the current state
localparam IDLE = 2'b00; // Initial state
localparam PULSE_DETECT = 2'b01; // State for pulse detection

reg [1:0] counter; // 2-bit counter to track the number of clock cycles

// Asynchronous reset
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        counter <= 0;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    state <= PULSE_DETECT;
                    counter <= 1;
                end
            end
            PULSE_DETECT: begin
                if (data_in) begin
                    counter <= counter + 1;
                    if (counter == 3) begin
                        data_out <= 1;
                        counter <= 0;
                        state <= IDLE;
                    end
                end else begin
                    counter <= 0;
                    state <= IDLE;
                end
            end
        endcase
    end
end

// Combinational logic to reset data_out
always @(*) begin
    if (state == IDLE && data_out == 1) begin
        data_out <= 0;
    end
end

endmodule