module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] counter;  // 2-bit counter
reg [0:0] state;    // 1-bit state (IDLE or SHIFT_ENABLE)
reg shift_ena_reg;  // register for shift_ena

// Define states
parameter IDLE = 1'b0;
parameter SHIFT_ENABLE = 1'b1;

// Initialize state and counter
initial begin
    state = IDLE;
    counter = 2'b00;
    shift_ena_reg = 1'b0;
end

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        state = SHIFT_ENABLE;
        counter = 2'b00;
        shift_ena_reg = 1'b1;
    end else begin
        case (state)
            IDLE: begin
                shift_ena_reg = 1'b0;
            end
            SHIFT_ENABLE: begin
                if (counter == 2'b11) begin
                    state = IDLE;
                    shift_ena_reg = 1'b0;
                end else begin
                    counter = counter + 1'b1;
                    shift_ena_reg = 1'b1;
                end
            end
        endcase
    end
end

// Continuous assignment
assign shift_ena = shift_ena_reg;

endmodule