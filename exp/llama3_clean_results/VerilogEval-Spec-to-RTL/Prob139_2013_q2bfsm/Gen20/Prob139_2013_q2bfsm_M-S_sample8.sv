module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);
    reg [1:0] state;
    reg [1:0] seq_count;
    reg [1:0] y_count;

    always @ (posedge clk) begin
        if (!resetn) begin
            state <= 0;
            f <= 0;
            g <= 0;
            seq_count <= 0;
            y_count <= 0;
        end else begin
            case (state)
                0: begin
                    f <= 1;
                    if (x == 1) begin
                        seq_count <= 1;
                    end else begin
                        seq_count <= 0;
                    end
                    if (seq_count == 0) begin
                        state <= 0;
                    end else if (seq_count == 1 && x == 0) begin
                        seq_count <= 2;
                        state <= 0;
                    end else if (seq_count == 2 && x == 1) begin
                        seq_count <= 0;
                        state <= 1;
                    end else begin
                        seq_count <= 0;
                        state <= 0;
                    end
                end
                1: begin
                    f <= 0;
                    if (y_count < 2) begin
                        if (y) begin
                            g <= 1;
                            y_count <= 0;
                        end else begin
                            y_count <= y_count + 1;
                        end
                    end else begin
                        g <= 0;
                    end
                end
            endcase
        end
    end
endmodule