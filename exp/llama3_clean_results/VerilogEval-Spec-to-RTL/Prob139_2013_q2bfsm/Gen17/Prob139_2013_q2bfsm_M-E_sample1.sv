module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state;
reg [1:0] y_count;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= 2'b00;
        y_count <= 2'b00;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            2'b00: begin // Idle
                if (resetn) begin
                    state <= 2'b01;
                    f <= 1;
                end
            end
            2'b01: begin // Seq1
                state <= 2'b10;
                f <= 0;
            end
            2'b10: begin // Seq2
                if (x == 1'b0) begin
                    state <= 2'b11;
                end else begin
                    state <= 2'b10;
                end
            end
            2'b11: begin // Active
                if (x == 1'b1) begin
                    state <= 2'b11;
                    if (y_count == 2'b00) begin
                        y_count <= y_count + 1;
                        if (y == 1'b1) begin
                            g <= 1;
                        end
                    end else if (y_count == 2'b01) begin
                        y_count <= y_count + 1;
                        if (y == 1'b1) begin
                            g <= 1;
                        end else begin
                            g <= 0;
                        end
                    end
                end else begin
                    state <= 2'b10;
                end
            end
        endcase
    end
end

endmodule