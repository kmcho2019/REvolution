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

reg [1:0] state; // 2 bits to represent 4 states
reg [3:0] shift_count; // 4 bits to count 4 shifts
reg [3:0] pattern; // 4 bits to store the input pattern

assign shift_ena = (state == 1); // shift_ena is high in SHIFT state
assign counting = (state == 2); // counting is high in COUNT state
assign done = (state == 3); // done is high in DONE state

always @(posedge clk) begin
    if (reset) begin // synchronous reset
        state <= 0; // reset to IDLE state
        shift_count <= 0;
        pattern <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                pattern <= {pattern[2:0], data}; // shift pattern to the left and append new data
                if (pattern == 4'b1101) begin
                    state <= 1; // transition to SHIFT state
                    pattern <= 0;
                end
            end
            1: begin // SHIFT state
                shift_count <= shift_count + 1;
                if (shift_count == 4) begin
                    state <= 2; // transition to COUNT state
                    shift_count <= 0;
                end
            end
            2: begin // COUNT state
                if (done_counting) begin
                    state <= 3; // transition to DONE state
                end
            end
            3: begin // DONE state
                if (ack) begin
                    state <= 0; // transition to IDLE state
                end
            end
        endcase
    end
end

endmodule