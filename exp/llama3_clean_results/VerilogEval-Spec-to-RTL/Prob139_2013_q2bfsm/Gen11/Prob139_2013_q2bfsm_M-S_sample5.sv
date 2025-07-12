module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state; // 0: reset, 1: after reset, 2: tracking x sequence, 3: tracking y
reg [1:0] x_seq;
reg [1:0] y_count;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= 0;
        x_seq <= 0;
        y_count <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            0: begin
                state <= 1;
                f <= 1;
                x_seq <= 0;
                y_count <= 0;
            end
            1: begin
                state <= 2;
                f <= 0;
            end
            2: begin
                if (x) begin
                    x_seq <= x_seq + 1;
                end else begin
                    x_seq <= (x_seq == 1) ? 0 : x_seq;
                end
                if (x_seq == 3) begin
                    state <= 3;
                    g <= 1;
                end else if (x_seq == 1 && x == 0) begin
                    x_seq <= 0;
                end
            end
            3: begin
                if (y) begin
                    state <= 3;
                    y_count <= 0;
                end else begin
                    y_count <= y_count + 1;
                    if (y_count == 2) begin
                        g <= 0;
                    end
                end
            end
        endcase
    end
end

endmodule