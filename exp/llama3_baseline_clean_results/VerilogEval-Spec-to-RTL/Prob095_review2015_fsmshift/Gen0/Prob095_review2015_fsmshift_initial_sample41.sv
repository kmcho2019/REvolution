module TopModule(
    input clk,
    input reset,
    output shift_ena
);

reg [1:0] state; // 0: Idle, 1: ShiftEnable, 2: Counting, 3: Done
reg [1:0] counter; // counter for 4 clock cycles

always @ (posedge clk) begin
    if (reset) begin
        state <= 1; // reset to ShiftEnable state
        counter <= 0; // reset counter
        shift_ena <= 1; // assert shift_ena
    end else begin
        case(state)
            1'b1: begin // ShiftEnable state
                if (counter == 4'd3) begin
                    state <= 1'b0; // return to Idle state
                    shift_ena <= 1'b0; // deassert shift_ena
                end else begin
                    counter <= counter + 1; // increment counter
                end
            end
            1'b0: begin // Idle state
                shift_ena <= 1'b0; // deassert shift_ena
                counter <= 0; // reset counter
            end
            default: ;
        endcase
    end
end

endmodule