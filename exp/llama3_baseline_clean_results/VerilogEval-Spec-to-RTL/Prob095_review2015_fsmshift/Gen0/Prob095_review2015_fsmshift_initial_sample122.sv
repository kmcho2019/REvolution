module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] counter; // counter to count clock cycles
reg state; // state variable to track the current state (idle or shift)

always @(posedge clk) begin
    if (reset) begin
        // reset the counter and state
        counter <= 0;
        state <= 1'b1; // start shifting
    end else begin
        if (state) begin
            // if shifting, increment counter and check if done
            counter <= counter + 1;
            if (counter == 4'd3) begin
                // done shifting, reset counter and state
                counter <= 0;
                state <= 1'b0;
            end
        end
    end
end

always @(*) begin
    if (reset || state) begin
        // if resetting or shifting, assert shift_ena
        shift_ena = 1'b1;
    end else begin
        // otherwise, deassert shift_ena
        shift_ena = 1'b0;
    end
end

endmodule