module TopModule (
    input         clk,
    input         reset,
    input         data,
    input         done_counting,
    input         ack,
    output        shift_ena,
    output        counting,
    output        done
);

reg [1:0] state; // 0: Idle, 1: Shift, 2: Count, 3: Done
reg [3:0] shift_counter; // counter for shift state
reg [3:0] pattern_reg; // register to store the pattern and the duration
reg [3:0] data_reg; // register to store the current input data

// Initialize the state and counters
initial begin
    state = 0;
    shift_counter = 0;
    pattern_reg = 0;
    data_reg = 0;
end

always @ (posedge clk) begin
    if (reset) begin
        state = 0;
        shift_counter = 0;
        pattern_reg = 0;
        data_reg = 0;
    end
    else begin
        case (state)
            0: begin // Idle state
                if (data_reg == 4'b1101) begin
                    state = 1;
                    shift_counter = 0;
                end
                else begin
                    data_reg = {data_reg[2:0], data};
                end
            end
            1: begin // Shift state
                shift_counter = shift_counter + 1;
                pattern_reg = {pattern_reg[2:0], data};
                if (shift_counter == 4) begin
                    state = 2;
                end
            end
            2: begin // Count state
                if (done_counting) begin
                    state = 3;
                end
            end
            3: begin // Done state
                if (ack) begin
                    state = 0;
                end
            end
        endcase
    end
end

// Output logic
assign shift_ena = (state == 1)? 1'b1 : 1'b0;
assign counting = (state == 2)? 1'b1 : 1'b0;
assign done = (state == 3)? 1'b1 : 1'b0;

endmodule