module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

reg [1:0] state; // 4-state FSM
reg [3:0] shift_counter; // counter for shift_ena
reg [3:0] pattern_register; // register to store the pattern
reg detected; // flag to indicate pattern detection

always @(posedge clk) begin
    if (reset) begin // synchronous reset
        state <= 2'b00; // idle state
        shift_counter <= 4'b0000;
        pattern_register <= 4'b0000;
        detected <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // idle state
                pattern_register <= {pattern_register[2:0], data};
                if (pattern_register == 4'b1101) begin
                    state <= 2'b01; // pattern detected
                    detected <= 1'b1;
                end else begin
                    state <= 2'b00; // stay in idle state
                    detected <= 1'b0;
                end
            end
            2'b01: begin // pattern detected
                if (shift_counter < 4) begin
                    shift_counter <= shift_counter + 1;
                    state <= 2'b01; // stay in pattern detected state
                end else begin
                    shift_counter <= 4'b0000;
                    state <= 2'b10; // waiting for counters
                end
            end
            2'b10: begin // waiting for counters
                if (done_counting) begin
                    state <= 2'b11; // waiting for acknowledgment
                end else begin
                    state <= 2'b10; // stay in waiting for counters state
                end
            end
            2'b11: begin // waiting for acknowledgment
                if (ack) begin
                    state <= 2'b00; // reset to idle state
                end else begin
                    state <= 2'b11; // stay in waiting for acknowledgment state
                end
            end
        endcase
    end
end

assign shift_ena = (state == 2'b01);
assign counting = (state == 2'b10);
assign done = (state == 2'b11);

endmodule