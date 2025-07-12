module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [1:0] state, next_state;
reg [3:0] counter;

always @(*) begin
    case(state)
        2'b00: begin // IDLE state
            if (data == 1'b1) begin // first bit of the start sequence
                next_state = 2'b01;
            end else begin
                next_state = 2'b00;
            end
        end
        2'b01: begin // second bit of the start sequence
            if (data == 1'b1) begin
                next_state = 2'b10;
            end else begin
                next_state = 2'b00;
            end
        end
        2'b10: begin // third bit of the start sequence
            if (data == 1'b0) begin
                next_state = 2'b11;
            end else begin
                next_state = 2'b00;
            end
        end
        2'b11: begin // fourth bit of the start sequence
            if (data == 1'b1) begin
                next_state = 2'b00; // shift state
                counter = 4'd0;
            end else begin
                next_state = 2'b00;
            end
        end
        default: begin // SHIFT state
            if (counter == 4'd3) begin // shifted 4 bits
                next_state = 2'b01; // COUNTING state
            end else begin
                next_state = 2'b00; // stay in SHIFT state
                counter = counter + 1'b1;
            end
        end
    endcase
end

always @(*) begin
    case(state)
        2'b00: begin // IDLE or SHIFT state
            if (counter < 4'd4) begin
                shift_ena = 1'b1;
            end else begin
                shift_ena = 1'b0;
            end
            counting = 1'b0;
            done = 1'b0;
        end
        2'b01: begin // COUNTING state
            shift_ena = 1'b0;
            counting = 1'b1;
            done = 1'b0;
        end
        default: begin // DONE state
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b1;
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00;
    end else begin
        case(state)
            2'b01: begin // COUNTING state
                if (done_counting) begin
                    state <= 2'b10; // DONE state
                end else begin
                    state <= 2'b01;
                end
            end
            2'b10: begin // DONE state
                if (ack) begin
                    state <= 2'b00; // IDLE state
                end else begin
                    state <= 2'b10;
                end
            end
            default: begin
                state <= next_state;
            end
        endcase
    end
end

endmodule