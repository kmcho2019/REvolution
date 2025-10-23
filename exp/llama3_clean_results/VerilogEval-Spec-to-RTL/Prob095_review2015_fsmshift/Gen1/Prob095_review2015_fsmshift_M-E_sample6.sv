module TopModule(
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] count; // counter to keep track of the number of clock cycles
reg reset_mode; // flag to indicate reset mode

always @(posedge clk) begin
    if (reset) begin // if reset is high, enter reset mode
        reset_mode <= 1'b1;
        count <= 2'd0;
        shift_ena <= 1'b1;
    end else if (reset_mode) begin // if in reset mode, increment counter and check if count is complete
        count <= count + 1'b1;
        if (count == 4'd3) begin // if count is complete, exit reset mode
            reset_mode <= 1'b0;
            shift_ena <= 1'b0;
        end else begin // if count is not complete, assert shift_ena
            shift_ena <= 1'b1;
        end
    end else begin // if in idle mode, keep shift_ena de-asserted
        shift_ena <= 1'b0;
    end
end

endmodule