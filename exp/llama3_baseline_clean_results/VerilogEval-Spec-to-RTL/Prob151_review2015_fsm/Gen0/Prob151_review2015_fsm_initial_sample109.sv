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

reg [1:0] state;
reg [1:0] next_state;
reg [2:0] shift_count;

// State encoding:
// 00: IDLE
// 01: SHIFT
// 10: COUNT
// 11: DONE

// Output encoding:
// shift_ena: 1 when in SHIFT state
// counting: 1 when in COUNT state
// done: 1 when in DONE state

always @(*) begin
    case(state)
        2'b00: begin // IDLE
            if (data == 1'b1) begin // start sequence detected
                next_state = 2'b01;
            end else begin
                next_state = 2'b00;
            end
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b0;
        end
        2'b01: begin // SHIFT
            if (shift_count == 4'd3) begin // 4 clock cycles passed
                next_state = 2'b10;
            end else begin
                next_state = 2'b01;
            end
            shift_ena = 1'b1;
            counting = 1'b0;
            done = 1'b0;
        end
        2'b10: begin // COUNT
            if (done_counting) begin
                next_state = 2'b11;
            end else begin
                next_state = 2'b10;
            end
            shift_ena = 1'b0;
            counting = 1'b1;
            done = 1'b0;
        end
        2'b11: begin // DONE
            if (ack) begin
                next_state = 2'b00;
            end else begin
                next_state = 2'b11;
            end
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b1;
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00;
        shift_count <= 3'd0;
    end else begin
        state <= next_state;
        if (state == 2'b01) begin
            shift_count <= shift_count + 1;
        end else begin
            shift_count <= 3'd0;
        end
    end
end

endmodule