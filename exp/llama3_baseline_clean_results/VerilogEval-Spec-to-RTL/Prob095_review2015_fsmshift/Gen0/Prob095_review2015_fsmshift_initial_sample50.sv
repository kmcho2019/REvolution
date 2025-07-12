module TopModule(
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] state; // 0: IDLE, 1: SHIFT, 2: SHIFT_1, 3: SHIFT_2, 
                  // but to save space we will use the counter to 
                  // generate the shift_ena signal
reg [1:0] counter; // counter to keep track of the number of clock cycles

always @(posedge clk) begin
    if(reset) begin
        state <= 1; // go to SHIFT state when reset
        counter <= 0; // reset counter
        shift_ena <= 1'b1; // assert shift_ena when reset
    end else begin
        case(state)
            1'b1: begin // SHIFT state
                if(counter == 4'd3) begin
                    state <= 1'b0; // go to IDLE state after 4 cycles
                    counter <= 0; // reset counter
                    shift_ena <= 1'b0; // deassert shift_ena
                end else begin
                    counter <= counter + 1; // increment counter
                    shift_ena <= 1'b1; // assert shift_ena
                end
            end
            default: begin // IDLE state
                state <= 1'b0; // stay in IDLE state
                shift_ena <= 1'b0; // deassert shift_ena
            end
        endcase
    end
end

endmodule