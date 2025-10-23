module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // Idle (2'b00) and Convert (2'b01)
reg invert; // track whether to invert bits after first '1'
reg first_one; // track whether first '1' has been encountered

always @(posedge clk or posedge areset) begin
    if (areset) begin // reset
        state <= 2'b00; // go to Idle state
        invert <= 1'b0; // reset invert flip-flop
        first_one <= 1'b0; // reset first_one flip-flop
        z <= 1'b0; // reset output
    end else begin
        case(state)
            2'b00: begin // Idle state
                if (!areset) begin
                    state <= 2'b01; // transition to Convert state when reset is released
                end
            end
            2'b01: begin // Convert state
                if (x && !first_one) begin
                    first_one <= 1'b1; // set first_one flip-flop
                end
                if (first_one) begin
                    invert <= 1'b1; // set invert flip-flop after first '1'
                end
                z <= (x ^ invert); // output the 2's complement bit
                if (areset) begin // stop conversion when reset is asserted
                    state <= 2'b00; // go to Idle state
                end
            end
        endcase
    end
end

endmodule