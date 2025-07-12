module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output reg f,
    output reg g
);

reg [2:0] state; // 0: reset, 1: pulse f, 2: detect sequence, 3: detect y, 4: g high

reg [1:0] x_count; // count for x sequence
reg y_count; // count for y detection

always @ (posedge clk) begin
    if (!resetn) begin
        state <= 0;
        f <= 0;
        g <= 0;
        x_count <= 0;
        y_count <= 0;
    end else begin
        case (state)
            0: begin // reset
                if (x == 1) begin
                    state <= 2;
                end
            end
            1: begin // pulse f
                f <= 1;
                state <= 2;
            end
            2: begin // detect sequence
                if (x) begin
                    x_count <= x_count + 1;
                end else begin
                    x_count <= 0;
                end
                if (x_count == 3) begin // 1, 0, 1 sequence detected
                    state <= 3;
                end
            end
            3: begin // detect y
                y_count <= y_count + 1;
                if (y) begin
                    state <= 4;
                    g <= 1;
                end else if (y_count == 2) begin // y not detected within 2 cycles
                    state <= 2;
                    g <= 0;
                end
            end
            4: begin // g high
                g <= 1;
                f <= 0;
            end
        endcase
        if (state == 1) begin
            f <= 0;
        end
        if (state != 1) begin
            if (resetn && state == 0) begin
                state <= 1;
            end
        end
    end
end

endmodule