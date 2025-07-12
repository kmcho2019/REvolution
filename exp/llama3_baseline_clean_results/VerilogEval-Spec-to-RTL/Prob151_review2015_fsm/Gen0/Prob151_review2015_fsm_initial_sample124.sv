module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

reg [2:0] state, next_state;
reg [3:0] pattern;
reg [2:0] shift_cnt;

// initialize outputs
assign shift_ena = (state == 3'b001) || (state == 3'b010) || (state == 3'b011) || (state == 3'b100);
assign counting = (state == 3'b101);
assign done = (state == 3'b110);

// sequence detection
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b000;
        pattern <= 4'b0000;
        shift_cnt <= 3'b000;
    end
    else begin
        state <= next_state;
        if (state == 3'b000) begin
            pattern <= {data, pattern[3:1]};
        end
        else if ((state == 3'b001) || (state == 3'b010) || (state == 3'b011) || (state == 3'b100)) begin
            shift_cnt <= shift_cnt + 1;
        end
        else if (state == 3'b101) begin
            // do nothing
        end
        else if (state == 3'b110) begin
            // do nothing
        end
    end
end

// next state logic
always @(*) begin
    next_state = state;
    case (state)
        3'b000: begin
            if (pattern == 4'b1101) begin
                next_state = 3'b001;
            end
        end
        3'b001, 3'b010, 3'b011, 3'b100: begin
            if (shift_cnt == 3'b100) begin
                next_state = 3'b101;
            end
        end
        3'b101: begin
            if (done_counting) begin
                next_state = 3'b110;
            end
        end
        3'b110: begin
            if (ack) begin
                next_state = 3'b000;
            end
        end
    endcase
end

endmodule