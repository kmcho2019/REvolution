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
            state <= 3'b000;
            f <= 0;
            g <= 0;
            y_count <= 0;
        end else begin
            case (state)
                3'b000: begin
                    state <= 3'b001;
                    f <= 1;
                end
                3'b001: begin
                    state <= 3'b010;
                    f <= 0;
                end
                3'b010: begin
                    if (x) begin
                        state <= 3'b011;
                    end
                end
                3'b011: begin
                    if (!x) begin
                        state <= 3'b100;
                    end else begin
                        state <= 3'b011;
                    end
                end
                3'b100: begin
                    if (x) begin
                        state <= 3'b101;
                    end else begin
                        state <= 3'b010;
                    end
                end
                3'b101: begin
                    state <= 3'b110;
                    g <= 1;
                end
                3'b110: begin
                    if (y) begin
                        g <= 1;
                        y_count <= 0;
                    end else if (y_count == 2) begin
                        g <= 0;
                        y_count <= 0;
                    end else begin
                        y_count <= y_count + 1;
                    end
                end
            endcase
        end
    end
endmodule