module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state = 2'b00; // idle state
reg invert = 1'b0; // initially, do not invert
reg first_one_detected = 1'b0; // flag for first '1' detection

always @(posedge clk or posedge areset) begin
    if (areset) begin // reset
        state <= 2'b00; // go back to idle state
        invert <= 1'b0;
        first_one_detected <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // idle
                if (x) begin
                    state <= 2'b01; // go to run state
                    first_one_detected <= 1'b1;
                end
            end
            2'b01: begin // run
                // do nothing, just stay in this state until reset
            end
        endcase
    end
end

assign z = first_one_detected ? ~x : 1'b0;

endmodule