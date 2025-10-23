module counter_12(
    input rst_n,  // Reset signal (active low)
    input clk,    // Clock signal
    input valid_count,  // Signal to enable counting
    output [3:0] out  // 4-bit output representing the current count value
);

reg [3:0] count_reg;  // Internal register to hold the count value
reg [1:0] state_reg;  // Internal register to hold the current state
localparam IDLE = 2'b00, COUNTING = 2'b01;

always @(posedge clk) begin
    if (!rst_n) begin  // If reset is active, reset the FSM and counter
        state_reg <= IDLE;
        count_reg <= 4'b0000;
    end else begin
        case (state_reg)
            IDLE: begin
                if (valid_count) begin  // If valid_count is 1, transition to COUNTING state
                    state_reg <= COUNTING;
                end
                count_reg <= count_reg;  // Retain current count value
            end
            COUNTING: begin
                if (!valid_count) begin  // If valid_count is 0, transition to IDLE state
                    state_reg <= IDLE;
                end
                if (count_reg == 4'd11) begin  // If count is at maximum, wrap around to 0
                    count_reg <= 4'b0000;
                end else begin  // Otherwise, increment the count
                    count_reg <= count_reg + 1;
                end
            end
        endcase
    end
end

assign out = count_reg;  // Drive the output port with the count value

endmodule