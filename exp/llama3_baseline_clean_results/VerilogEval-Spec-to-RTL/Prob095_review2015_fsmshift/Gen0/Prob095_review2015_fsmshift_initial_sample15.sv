module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] state; // 2 states: IDLE (2'b00) and SHIFT_ENABLE (2'b01, 2'b10, 2'b11)
reg [1:0] counter; // counter to keep track of the number of clock cycles

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b01; // start shifting when reset is asserted
        counter <= 2'b00; // reset counter
        shift_ena <= 1'b1; // assert shift_ena
    end else begin
        case (state)
            2'b00: begin // IDLE state
                shift_ena <= 1'b0; // deassert shift_ena
            end
            2'b01, 2'b10, 2'b11: begin // SHIFT_ENABLE state
                shift_ena <= 1'b1; // assert shift_ena
                counter <= counter + 1'b1; // increment counter
                if (counter == 2'b11) begin // 4 clock cycles have passed
                    state <= 2'b00; // transition to IDLE state
                    counter <= 2'b00; // reset counter
                end else begin
                    case (counter)
                        2'b01: state <= 2'b10;
                        2'b10: state <= 2'b11;
                        default: state <= 2'b01;
                    endcase
                end
            end
            default: begin
                state <= 2'b00;
                shift_ena <= 1'b0;
            end
        endcase
    end
end

endmodule