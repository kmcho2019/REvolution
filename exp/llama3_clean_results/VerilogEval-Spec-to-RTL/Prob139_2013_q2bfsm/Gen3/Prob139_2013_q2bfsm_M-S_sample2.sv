module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state;
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
                f <= 1;
                state <= 1;
            end
            1: begin
                if (x == 1) x_seq <= x_seq + 1;
                if (x_seq == 3) begin
                    state <= 2;
                    x_seq <= 0;
                end
            end
            2: begin
                if (y_count < 2) begin
                    if (y) begin
                        g <= 1;
                        state <= 3;
                    end else begin
                        y_count <= y_count + 1;
                    end
                end else begin
                    g <= 0;
                    state <= 4;
                end
            end
            3, 4: begin
                f <= 0;
            end
        endcase
    end
end

endmodule