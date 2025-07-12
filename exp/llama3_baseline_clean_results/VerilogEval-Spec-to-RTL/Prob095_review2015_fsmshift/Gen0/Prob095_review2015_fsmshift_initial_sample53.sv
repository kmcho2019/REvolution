module TopModule(
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] state; // 0: idle, 1: shifting, 2: shifting (to avoid using a 2-bit counter)
reg [1:0] counter; // counter to keep track of the number of clock cycles

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // enter shifting state on reset
        counter <= 0; // reset counter
        shift_ena <= 1; // assert shift_ena on reset
    end else begin
        case (state)
            1: begin // shifting state
                if (counter == 3) begin // if counter reaches 3, go to idle state
                    state <= 0;
                    shift_ena <= 0; // deassert shift_ena
                end else begin
                    counter <= counter + 1; // increment counter
                    shift_ena <= 1; // keep shift_ena asserted
                end
            end
            0: begin // idle state
                shift_ena <= 0; // keep shift_ena deasserted
            end
        endcase
    end
end

endmodule