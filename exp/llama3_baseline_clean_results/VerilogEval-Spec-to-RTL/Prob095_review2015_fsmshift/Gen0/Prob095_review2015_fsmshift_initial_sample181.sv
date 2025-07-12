module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // state register
reg [1:0] counter; // counter to count clock cycles in SHIFT state

// state encoding
parameter IDLE = 2'b00;
parameter SHIFT = 2'b01;

// next-state logic
always @(posedge clk) begin
    if (reset) begin
        state <= SHIFT;
        counter <= 2'b00;
    end else begin
        case (state)
            IDLE: begin
                state <= IDLE;
                shift_ena <= 1'b0;
            end
            SHIFT: begin
                if (counter == 2'b11) begin
                    state <= IDLE;
                    shift_ena <= 1'b0;
                end else begin
                    state <= SHIFT;
                    shift_ena <= 1'b1;
                    counter <= counter + 1'b1;
                end
            end
            default: begin
                state <= IDLE;
                shift_ena <= 1'b0;
            end
        endcase
    end
end

endmodule