module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] state; // 0: idle, 1: shifting, 2: shifting_1, 3: shifting_2
reg [1:0] counter;

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // start shifting on reset
        counter <= 0;
        shift_ena <= 1;
    end else begin
        case(state)
            1: begin
                counter <= counter + 1;
                if (counter == 4) begin
                    state <= 0; // done shifting
                    shift_ena <= 0;
                end else begin
                    shift_ena <= 1;
                end
            end
            default: begin
                state <= state; // stay in idle state
                counter <= counter;
                shift_ena <= 0;
            end
        endcase
    end
end

endmodule