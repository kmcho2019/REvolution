module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

// Pattern detection module
reg [3:0] pattern_reg;
reg pattern_detected;

always @(posedge clk) begin
    if (reset) begin
        pattern_reg <= 0;
        pattern_detected <= 0;
    end
    else begin
        pattern_reg <= {pattern_reg[2:0], data};
        if (pattern_reg == 4'b1101) begin
            pattern_detected <= 1;
        end
        else begin
            pattern_detected <= 0;
        end
    end
end

// Duration counting module
reg [3:0] duration_reg;
reg [3:0] duration_count;

always @(posedge clk) begin
    if (reset) begin
        duration_reg <= 0;
        duration_count <= 0;
    end
    else if (shift_ena) begin
        duration_reg <= {duration_reg[2:0], data};
        duration_count <= duration_count + 1;
    end
end

// State management module
reg [1:0] state;
parameter IDLE = 2'b00;
parameter SHIFT = 2'b01;
parameter COUNT = 2'b10;
parameter WAIT_ACK = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                if (pattern_detected) begin
                    state <= SHIFT;
                    shift_ena <= 1;
                end
            end
            SHIFT: begin
                if (duration_count == 4) begin
                    state <= COUNT;
                    shift_ena <= 0;
                    counting <= 1;
                end
            end
            COUNT: begin
                if (done_counting) begin
                    state <= WAIT_ACK;
                    counting <= 0;
                    done <= 1;
                end
            end
            WAIT_ACK: begin
                if (ack) begin
                    state <= IDLE;
                    done <= 0;
                end
            end
            default: begin
                state <= IDLE;
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
        endcase
    end
end

endmodule