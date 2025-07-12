module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

reg [2:0] state; // 0: A, 1: B, 2: C, 3: D, 4: E
reg [1:0] x_count;
reg [1:0] y_count;
reg g_val;

always @(posedge clk) begin
    if (!resetn) begin
        state <= 0;
        f <= 0;
        g <= 0;
        x_count <= 0;
        y_count <= 0;
        g_val <= 0;
    end else begin
        case (state)
            0: begin // A
                state <= 1;
                f <= 1;
                g <= 0;
                x_count <= 0;
                y_count <= 0;
                g_val <= 0;
            end
            1: begin // B
                state <= 2;
                f <= 0;
            end
            2: begin // C
                if (x) begin
                    x_count <= x_count + 1;
                end else begin
                    x_count <= 0;
                end
                if (x_count == 3) begin
                    state <= 3;
                end
            end
            3: begin // D
                state <= 4;
                g_val <= 1;
            end
            4: begin // E
                if (g_val) begin
                    if (y) begin
                        y_count <= 0;
                    end else begin
                        y_count <= y_count + 1;
                        if (y_count == 2) begin
                            g_val <= 0;
                        end
                    end
                end
            end
        endcase
    end
end

assign f = (state == 1);
assign g = g_val;

endmodule