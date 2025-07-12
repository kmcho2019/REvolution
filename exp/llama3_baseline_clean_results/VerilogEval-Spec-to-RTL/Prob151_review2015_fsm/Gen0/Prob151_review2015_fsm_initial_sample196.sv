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

reg [3:0] state; // Idle, Shift, Count, Done
reg [3:0] nextState;

localparam IDLE = 4'b0000;
localparam SHIFT = 4'b0001;
localparam COUNT = 4'b0010;
localparam DONE = 4'b0011;
localparam RESET = 4'b0100;

reg [3:0] pattern; // pattern to detect (1101)

always @(*) begin
    case(state)
        IDLE: begin
            if(pattern == 4'b1101) begin
                nextState = SHIFT;
            end else begin
                nextState = IDLE;
            end
        end
        SHIFT: begin
            if(pattern == 4'b1111) begin // just a dummy value to show that we have shifted 4 bits
                nextState = COUNT;
            end else begin
                nextState = SHIFT;
            end
        end
        COUNT: begin
            if(done_counting) begin
                nextState = DONE;
            end else begin
                nextState = COUNT;
            end
        end
        DONE: begin
            if(ack) begin
                nextState = IDLE;
            end else begin
                nextState = DONE;
            end
        end
        default: begin
            nextState = IDLE;
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= IDLE;
        pattern <= 4'b0000;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        state <= nextState;
        if(nextState == SHIFT) begin
            shift_ena <= 1'b1;
            counting <= 1'b0;
            done <= 1'b0;
        end else if(nextState == COUNT) begin
            shift_ena <= 1'b0;
            counting <= 1'b1;
            done <= 1'b0;
        end else if(nextState == DONE) begin
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b1;
        end else begin
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end
        if(state == IDLE) begin
            pattern <= {pattern[2:0], data};
        end else if(state == SHIFT) begin
            pattern <= {pattern[2:0], data};
        end
    end
end

endmodule