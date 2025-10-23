`define STATE_A 4'b0000
`define STATE_B 4'b0001
`define STATE_C 4'b0010
`define STATE_D 4'b0011
`define STATE_E 4'b0100
`define STATE_F 4'b0101

module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

reg [3:0] current_state;
reg [3:0] next_state;

always @(posedge clk) begin
    if (~resetn) begin
        current_state <= `STATE_A;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case (current_state)
        `STATE_A: begin
            if (resetn) begin
                next_state = `STATE_B;
            end else begin
                next_state = `STATE_A;
            end
            f = 0;
            g = 0;
        end
        `STATE_B: begin
            next_state = `STATE_C;
            f = 1;
            g = 0;
        end
        `STATE_C: begin
            if (x) begin
                next_state = {1'b1, current_state[2:0]};
            end else begin
                next_state = `STATE_C;
            end
            if (current_state[2:0] == 3'b101) begin
                next_state = `STATE_D;
            end
            f = 0;
            g = 0;
        end
        `STATE_D: begin
            if (y || current_state[1:0] == 2'b10) begin
                next_state = `STATE_E;
            end else if (current_state[1:0] == 2'b01) begin
                next_state = {1'b0, current_state[2:0]};
            end else begin
                next_state = {1'b0, current_state[2:0]} + 1;
            end
            g = 1;
            f = 0;
        end
        `STATE_E: begin
            next_state = `STATE_E;
            f = 0;
            g = 1;
        end
        `STATE_F: begin
            next_state = `STATE_F;
            f = 0;
            g = 0;
        end
        default: begin
            next_state = `STATE_A;
            f = 0;
            g = 0;
        end
    endcase
end

endmodule