module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    reg [1:0] state;
    reg [1:0] x_cnt;
    reg [1:0] y_cnt;

    // Define states
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    always @(posedge clk) begin
        if (~resetn) begin
            state <= A;
            f <= 0;
            g <= 0;
            x_cnt <= 0;
            y_cnt <= 0;
        end else begin
            case (state)
                A: begin
                    if (resetn) begin
                        state <= B;
                    end
                end
                B: begin
                    f <= 1;
                    state <= C;
                end
                C: begin
                    f <= 0;
                    if (x_cnt == 0 && x) begin
                        x_cnt <= x_cnt + 1;
                    end else if (x_cnt == 1 && ~x) begin
                        x_cnt <= x_cnt + 1;
                    end else if (x_cnt == 2 && x) begin
                        x_cnt <= 0;
                        state <= D;
                    end else begin
                        x_cnt <= 0;
                    end
                end
                D: begin
                    g <= 1;
                    if (y || y_cnt == 2) begin
                        state <= A;
                        if (y) begin
                            f <= 0;
                            g <= 1;
                        end else begin
                            f <= 0;
                            g <= 0;
                        end
                    end else begin
                        y_cnt <= y_cnt + 1;
                    end
                end
            endcase
        end
    end

endmodule