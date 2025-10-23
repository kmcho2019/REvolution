`define STATE_A 3'd0
`define STATE_B 3'd1
`define STATE_C 3'd2
`define STATE_D 3'd3
`define STATE_E 3'd4

module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output reg f,
    output reg g
);

reg [2:0] current_state;
reg [2:0] next_state;
reg [1:0] x_seq_counter;
reg [1:0] y_timer;

always @(posedge clk) begin
    if (~resetn) begin
        current_state <= `STATE_A;
        f <= 0;
        g <= 0;
        x_seq_counter <= 0;
        y_timer <= 0;
    end else begin
        current_state <= next_state;
        case (current_state)
            `STATE_A: begin
                f <= 0;
                g <= 0;
            end
            `STATE_B: begin
                f <= 1;
                g <= 0;
            end
            `STATE_C: begin
                f <= 0;
                g <= 0;
            end
            `STATE_D: begin
                f <= 0;
                g <= 1;
            end
            `STATE_E: begin
                f <= 0;
                g <= 0;
            end
        endcase
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
            x_seq_counter = 0;
            y_timer = 0;
        end
        `STATE_B: begin
            next_state = `STATE_C;
        end
        `STATE_C: begin
            if (x_seq_counter == 2'd3) begin
                next_state = `STATE_D;
                x_seq_counter = 0;
            end else begin
                next_state = `STATE_C;
                case (x_seq_counter)
                    2'd0: begin
                        if (x) begin
                            x_seq_counter = 2'd1;
                        end else begin
                            x_seq_counter = 2'd0;
                        end
                    end
                    2'd1: begin
                        if (~x) begin
                            x_seq_counter = 2'd2;
                        end else begin
                            x_seq_counter = 2'd0;
                        end
                    end
                    2'd2: begin
                        if (x) begin
                            x_seq_counter = 2'd3;
                        end else begin
                            x_seq_counter = 2'd0;
                        end
                    end
                endcase
            end
        end
        `STATE_D: begin
            if (y) begin
                next_state = `STATE_D;
                y_timer = 0;
            end else begin
                y_timer = y_timer + 1;
                if (y_timer == 2'd2) begin
                    next_state = `STATE_E;
                end else begin
                    next_state = `STATE_D;
                end
            end
        end
        `STATE_E: begin
            next_state = `STATE_E;
        end
    endcase
end

endmodule