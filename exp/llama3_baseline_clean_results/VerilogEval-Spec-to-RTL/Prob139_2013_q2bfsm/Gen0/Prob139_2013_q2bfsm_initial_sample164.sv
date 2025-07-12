module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define states
parameter A = 4'b0000;
parameter B = 4'b0001;
parameter C = 4'b0010;
parameter D = 4'b0011;
parameter E = 4'b0100;
parameter F = 4'b0101;

reg [3:0] state, next_state;

// Counter to keep track of the number of clock cycles
reg [1:0] count_x, count_y;

// Sequence counter for x
reg [1:0] x_seq;

always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
        count_x <= 0;
        count_y <= 0;
        x_seq <= 0;
    end else begin
        case(state)
            A: begin
                if (resetn) begin
                    state <= B;
                end else begin
                    state <= A;
                end
                f <= 0;
                g <= 0;
                count_x <= 0;
                count_y <= 0;
                x_seq <= 0;
            end
            B: begin
                state <= C;
                f <= 1;
                g <= 0;
                count_x <= 0;
                count_y <= 0;
                x_seq <= 0;
            end
            C: begin
                state <= C;
                f <= 0;
                g <= 0;
                if (x) begin
                    if (x_seq == 2'b00) begin
                        x_seq <= 2'b01;
                    end else if (x_seq == 2'b10) begin
                        x_seq <= 2'b11;
                    end
                end else if (x_seq == 2'b01) begin
                    x_seq <= 2'b10;
                end else begin
                    x_seq <= 2'b00;
                end
                if (x_seq == 2'b11) begin
                    state <= D;
                end
                count_x <= 0;
                count_y <= 0;
            end
            D: begin
                state <= D;
                f <= 0;
                g <= 1;
                if (y) begin
                    state <= E;
                end else begin
                    count_y <= count_y + 1;
                    if (count_y == 2) begin
                        state <= F;
                    end
                end
                count_x <= 0;
            end
            E: begin
                state <= E;
                f <= 0;
                g <= 1;
                count_x <= 0;
                count_y <= 0;
            end
            F: begin
                state <= F;
                f <= 0;
                g <= 0;
                count_x <= 0;
                count_y <= 0;
            end
        endcase
    end
end

endmodule