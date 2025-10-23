module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] state;
reg [1:0] counter;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b01; // RESET state
        counter <= 2'b00; // reset counter
        shift_ena <= 1'b1;
    end else begin
        case (state)
            2'b01: begin // RESET state
                if (counter == 4'd3) begin
                    state <= 2'b10; // DONE state
                    shift_ena <= 1'b0;
                end else begin
                    counter <= counter + 1'b1;
                end
            end
            2'b10: begin // DONE state
                // do nothing
            end
            default: begin // IDLE state
                // do nothing
            end
        endcase
    end
end

endmodule