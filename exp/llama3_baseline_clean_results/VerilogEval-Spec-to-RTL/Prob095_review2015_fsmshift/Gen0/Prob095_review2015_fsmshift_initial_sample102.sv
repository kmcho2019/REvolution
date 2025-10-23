module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] state; // 0: idle, 1: shift, 2: counting
reg [1:0] counter; // counts the number of clock cycles

always @(posedge clk) begin
    if(reset) begin
        state <= 1; // go to shift state when reset
        counter <= 0; // reset counter
        shift_ena <= 1; // assert shift_ena
    end else begin
        case(state)
            1: begin // shift state
                if(counter == 4'd3) begin // 4 cycles have passed
                    state <= 0; // go to idle state
                    shift_ena <= 0; // deassert shift_ena
                end else begin
                    counter <= counter + 1; // increment counter
                end
            end
            0: begin // idle state
                // do nothing
            end
        endcase
    end
end

endmodule