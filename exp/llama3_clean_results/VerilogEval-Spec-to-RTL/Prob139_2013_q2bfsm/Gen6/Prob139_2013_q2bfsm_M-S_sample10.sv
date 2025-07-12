module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state;
reg [1:0] y_count;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= 0;
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
                f <= 0;
                if (x) state <= 2;
            end
            2: begin
                if (!x) state <= 3;
            end
            3: begin
                if (x) begin
                    state <= 4;
                    y_count <= 0;
                end else state <= 1;
            end
            4: begin
                if (y) begin
                    g <= 1;
                    state <= 5;
                end else if (y_count < 2) begin
                    y_count <= y_count + 1;
                end else begin
                    g <= 0;
                    state <= 1;
                end
            end
            5: begin
                g <= 1;
            end
        endcase
    end
end

endmodule