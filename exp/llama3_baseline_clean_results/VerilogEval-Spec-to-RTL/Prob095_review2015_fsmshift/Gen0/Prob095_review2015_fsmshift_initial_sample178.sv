module TopModule(
    input           clk,
    input           reset,
    output          shift_ena
);

reg [1:0] state; // Idle, Shifting
reg [1:0] counter; // counts the number of clock cycles in shifting state

always @(posedge clk) begin
    if (reset) begin // synchronous reset
        state <= 1'b1; // enter shifting state
        counter <= 2'd0; // reset counter
        shift_ena <= 1'b1; // assert shift_ena
    end else begin
        case (state)
            1'b0: begin // idle state
                shift_ena <= 1'b0;
            end
            1'b1: begin // shifting state
                shift_ena <= 1'b1;
                counter <= counter + 1'b1;
                if (counter == 2'd3) begin // after 4 cycles
                    state <= 1'b0; // enter idle state
                    counter <= 2'd0; // reset counter
                end
            end
        endcase
    end
end

endmodule