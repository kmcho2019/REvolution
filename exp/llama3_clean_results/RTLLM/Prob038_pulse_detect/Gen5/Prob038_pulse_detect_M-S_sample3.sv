module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit register to keep track of the current state
localparam IDLE = 2'b00; // Initial state
localparam RISING = 2'b01; // State after data_in rises
localparam PULSE = 2'b10; // State indicating a pulse

// Asynchronous reset and state machine
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    state <= RISING;
                end else begin
                    state <= IDLE;
                end
                data_out <= 0;
            end
            RISING: begin
                if (data_in) begin
                    state <= RISING;
                end else begin
                    state <= PULSE;
                end
                data_out <= 0;
            end
            PULSE: begin
                state <= IDLE;
                data_out <= 1;
            end
        endcase
    end
end

endmodule