module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 0: idle, 1: shifting, 2-3: shifting with countdown
reg [1:0] counter; // countdown counter

always @(posedge clk) begin
    if(reset) begin
        state <= 1; // go to shifting state when reset
        counter <= 4'd4; // initialize countdown counter
        shift_ena <= 1'b1; // assert shift_ena
    end
    else begin
        case(state)
            1: begin
                state <= 2; // go to shifting with countdown state
                counter <= 4'd3; // decrement countdown counter
                shift_ena <= 1'b1; // assert shift_ena
            end
            2: begin
                if(counter > 4'd1) begin
                    counter <= counter - 1'b1; // decrement countdown counter
                    shift_ena <= 1'b1; // assert shift_ena
                end
                else begin
                    counter <= 4'd0; // reset countdown counter
                    state <= 0; // go to idle state
                    shift_ena <= 1'b0; // deassert shift_ena
                end
            end
            0: begin
                shift_ena <= 1'b0; // deassert shift_ena
            end
            default: begin
                state <= 0; // go to idle state
                shift_ena <= 1'b0; // deassert shift_ena
            end
        endcase
    end
end

endmodule