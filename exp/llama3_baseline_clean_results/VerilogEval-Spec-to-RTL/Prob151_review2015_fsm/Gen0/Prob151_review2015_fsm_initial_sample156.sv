module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

reg [3:0] state;
reg [3:0] next_state;
reg [2:0] shift_counter;
reg [3:0] pattern_detector;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 0;
        pattern_detector <= 0;
        shift_counter <= 0;
    end else begin
        state <= next_state;
        pattern_detector <= (pattern_detector << 1) | data;
        if(next_state == 2) begin
            shift_counter <= shift_counter + 1;
        end else begin
            shift_counter <= 0;
        end
    end
end

always @(*) begin
    case(state)
        0: begin // IDLE
            if(pattern_detector == 4'b1101) begin
                next_state = 1; // DETECTED
            end else begin
                next_state = 0;
            end
        end
        1: begin // DETECTED
            next_state = 2; // SHIFTING
        end
        2: begin // SHIFTING
            if(shift_counter == 4) begin
                next_state = 3; // COUNTING
            end else begin
                next_state = 2;
            end
        end
        3: begin // COUNTING
            if(done_counting) begin
                next_state = 4; // DONE
            end else begin
                next_state = 3;
            end
        end
        4: begin // DONE
            if(ack) begin
                next_state = 0; // IDLE
            end else begin
                next_state = 4;
            end
        end
    endcase
end

assign shift_ena = (state == 2);
assign counting = (state == 3);
assign done = (state == 4);

endmodule