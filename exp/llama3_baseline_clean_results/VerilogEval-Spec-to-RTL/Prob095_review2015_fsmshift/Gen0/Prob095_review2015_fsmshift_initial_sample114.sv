module TopModule(
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] state; // 0: idle, 1: shifting, 2: shifting (counting), 3: shifting (counting)
reg [1:0] counter;

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // shifting state
        counter <= 0;
        shift_ena <= 1;
    end else begin
        case(state)
            1: begin
                counter <= counter + 1;
                if (counter == 3) begin
                    state <= 0; // idle state
                    shift_ena <= 0;
                end else begin
                    state <= 1; // shifting state
                    shift_ena <= 1;
                end
            end
            0: begin
                state <= 0; // idle state
                shift_ena <= 0;
            end
            default: state <= 0;
        endcase
    end
end

endmodule