module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

// Define states for the FSM
enum logic [1:0] {IDLE, MULT, DONE} state, next_state;

// Registers
reg [4:0] i;
reg [31:0] yout_r;
reg [15:0] areg, breg;

// Clock enable signal
reg clock_enable;

// Next state logic
always_comb begin
    case(state)
        IDLE: begin
            if (start) next_state = MULT;
            else next_state = IDLE;
        end
        MULT: begin
            if (i < 16) next_state = MULT;
            else next_state = DONE;
        end
        DONE: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if (!rst_n) begin
        state <= IDLE;
        i <= 5'd0;
        yout_r <= 32'd0;
        areg <= 16'd0;
        breg <= 16'd0;
        clock_enable <= 1'b0;
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
                    clock_enable <= 1'b1;
                    done <= 1'b0;
                end else begin
                    clock_enable <= 1'b0;
                end
            end
            MULT: begin
                if (areg[i] == 1'b1) begin
                    yout_r <= yout_r + (breg << i);
                end
                i <= i + 1'b1;
            end
            DONE: begin
                done <= 1'b1;
                clock_enable <= 1'b0;
            end
        endcase
    end
end

assign yout = yout_r;

endmodule