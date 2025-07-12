module TopModule(
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] state; // 0: IDLE, 1: SHIFT_COUNT
reg [1:0] count; // counter for shift enable cycles

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // go to SHIFT_COUNT state on reset
        count <= 0; // reset counter
        shift_ena <= 1; // assert shift_ena on reset
    end else begin
        case (state)
            1: begin // SHIFT_COUNT state
                if (count < 3) begin // count up to 3 (4 cycles)
                    count <= count + 1;
                    shift_ena <= 1; // keep shift_ena asserted
                end else begin
                    count <= 0; // reset counter
                    shift_ena <= 0; // deassert shift_ena
                    state <= 0; // go to IDLE state
                end
            end
            0: begin // IDLE state
                shift_ena <= 0; // keep shift_ena deasserted
            end
        endcase
    end
end

endmodule