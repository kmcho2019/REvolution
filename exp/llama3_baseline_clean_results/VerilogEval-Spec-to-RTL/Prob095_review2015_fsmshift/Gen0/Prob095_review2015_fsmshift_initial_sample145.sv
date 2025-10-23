module TopModule(
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] state; // Idle (2'b00), Shifting (2'b01)
reg [1:0] counter; // counts from 0 to 3

always @(posedge clk) begin
    if(reset) begin
        state <= 2'b01; // reset transitions to shifting state
        counter <= 2'b00; // reset counter
        shift_ena <= 1'b1; // assert shift_ena
    end
    else begin
        case(state)
            2'b01: begin // shifting state
                if(counter == 2'b11) begin // counter is 3, done shifting
                    state <= 2'b00; // transition to idle state
                    shift_ena <= 1'b0; // deassert shift_ena
                end
                else begin
                    counter <= counter + 1; // increment counter
                    shift_ena <= 1'b1; // keep shift_ena asserted
                end
            end
            2'b00: begin // idle state
                shift_ena <= 1'b0; // keep shift_ena deasserted
            end
            default: ; // this state should never be reached
        endcase
    end
end

endmodule