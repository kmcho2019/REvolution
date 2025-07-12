module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // Idle, Shifting
reg [1:0] counter; // Counter to keep track of shifting cycles
reg shift_ena_reg; // Register for shift_ena signal

// State definition
localparam IDLE = 2'b00;
localparam SHIFTING = 2'b01;

always @(posedge clk) begin
    if (reset) begin // Active high synchronous reset
        state <= SHIFTING;
        counter <= 2'b00;
        shift_ena_reg <= 1'b1;
    end else begin
        case (state)
            IDLE: begin
                // Remain in idle state, shift_ena remains 0
                shift_ena_reg <= 1'b0;
            end
            SHIFTING: begin
                // Assert shift_ena, increment counter
                shift_ena_reg <= 1'b1;
                counter <= counter + 1'b1;
                if (counter == 2'b11) begin // Counter has reached 4 (4 clock cycles)
                    state <= IDLE; // Transition back to idle state
                end
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;

endmodule