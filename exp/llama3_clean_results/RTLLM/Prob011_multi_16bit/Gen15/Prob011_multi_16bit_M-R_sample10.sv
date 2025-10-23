module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

// Define states for the state machine
enum logic [1:0] {IDLE, MULTIPLY, DONE} state, next_state;

reg [4:0] i;
reg [31:0] yout_r;
reg [15:0] areg, breg;

always @(*) begin
    case(state)
        IDLE: begin
            if (start) next_state = MULTIPLY;
            else next_state = IDLE;
        end
        MULTIPLY: begin
            if (i == 16) next_state = DONE;
            else next_state = MULTIPLY;
        end
        DONE: begin
            if (!start) next_state = IDLE;
            else next_state = DONE;
        end
    endcase
end

always @(posedge clk) begin
    if (!rst_n) begin
        state <= IDLE;
        i <= 5'd0;
        yout_r <= 32'd0;
        areg <= 16'd0;
        breg <= 16'd0;
        done <= 1'b0;
    end else begin
        state <= next_state;
        case(state)
            IDLE: begin
                if (start) begin
                    areg <= ain;
                    breg <= bin;
                    i <= 5'd0;
                    yout_r <= 32'd0;
                end
            end
            MULTIPLY: begin
                if (areg[i] == 1'b1) begin
                    yout_r <= yout_r + (breg << i);
                end
                i <= i + 1'b1;
            end
            DONE: begin
                done <= 1'b1;
            end
        endcase
        if (next_state == IDLE) begin
            done <= 1'b0;
            i <= 5'd0;
        end
    end
end

assign yout = yout_r;

endmodule