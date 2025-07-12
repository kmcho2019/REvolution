module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] counter;  // 2-bit counter to count 4 cycles
reg state;  // 1-bit state variable: 0 - IDLE, 1 - SHIFT_ENABLE

always @(posedge clk) begin
    if (reset) begin  // active high synchronous reset
        state <= 1'b1;  // go to SHIFT_ENABLE state
        counter <= 2'd0;  // reset counter
        shift_ena <= 1'b1;  // assert shift_ena
    end else begin
        case (state)
            1'b0: begin  // IDLE state
                shift_ena <= 1'b0;  // keep shift_ena low
            end
            1'b1: begin  // SHIFT_ENABLE state
                if (counter < 4'd3) begin  // check if counter is less than 3
                    counter <= counter + 1'b1;  // increment counter
                end else begin
                    state <= 1'b0;  // go back to IDLE state
                    shift_ena <= 1'b0;  // deassert shift_ena
                end
            end
        endcase
    end
end

endmodule