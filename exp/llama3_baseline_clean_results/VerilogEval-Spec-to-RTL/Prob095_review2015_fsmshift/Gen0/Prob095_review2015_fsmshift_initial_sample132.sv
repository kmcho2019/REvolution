module TopModule(
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] state; // Idle, ShiftEnable
reg [1:0] counter; // Counter for 4 clock cycles

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // ShiftEnable
        counter <= 0;
        shift_ena <= 1;
    end else begin
        case (state)
            1: begin // ShiftEnable
                if (counter == 3) begin
                    state <= 0; // Idle
                    shift_ena <= 0;
                end else begin
                    counter <= counter + 1;
                end
            end
            0: begin // Idle
                counter <= 0;
                shift_ena <= 0;
            end
        endcase
    end
end

endmodule