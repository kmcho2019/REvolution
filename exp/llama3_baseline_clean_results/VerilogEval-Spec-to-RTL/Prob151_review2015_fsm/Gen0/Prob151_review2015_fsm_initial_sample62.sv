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
reg [3:0] counter;

always @(posedge clk) begin
    if(reset) begin
        state <= 0;
        pattern <= 0;
        counter <= 0;
    end else begin
        state <= next_state;
        pattern <= {pattern[2:0], data};
        if(state == 1) begin
            if(counter == 4) begin
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end
end

always @(*) begin
    case(state)
        0: begin // IDLE
            if(pattern == 4'b1101) begin
                next_state = 1;
            end else begin
                next_state = 0;
            end
            shift_ena = 0;
            counting = 0;
            done = 0;
        end
        1: begin // SHIFT
            next_state = 1;
            if(counter == 4) begin
                next_state = 2;
            end
            shift_ena = 1;
            counting = 0;
            done = 0;
        end
        2: begin // COUNT
            next_state = 2;
            if(done_counting) begin
                next_state = 3;
            end
            shift_ena = 0;
            counting = 1;
            done = 0;
        end
        3: begin // DONE
            next_state = 3;
            if(ack) begin
                next_state = 0;
            end
            shift_ena = 0;
            counting = 0;
            done = 1;
        end
    endcase
end

endmodule