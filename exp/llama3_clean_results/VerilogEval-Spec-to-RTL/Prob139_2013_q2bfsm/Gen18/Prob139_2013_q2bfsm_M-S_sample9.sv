module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);
    reg [2:0] state;
    reg [1:0] x_seq;
    reg [1:0] y_count;
    always @ (posedge clk) begin
        if (!resetn) begin
            state <= 0;
            f <= 0;
            g <= 0;
            x_seq <= 0;
            y_count <= 0;
        end else begin
            case (state)
                0: begin
                    f <= 1;
                    state <= 1;
                end
                1: begin
                    f <= 0;
                    x_seq <= {x_seq[1:0], x};
                    if (x_seq == 5) begin // 101
                        state <= 2;
                    end
                end
                2: begin
                    g <= 1;
                    if (y) begin
                        state <= 3; // permanent state with g = 1
                    end else if (y_count == 2) begin
                        state <= 4; // permanent state with g = 0
                    end else begin
                        y_count <= y_count + 1;
                    end
                end
                3: ; // permanent state with g = 1
                4: ; // permanent state with g = 0
            endcase
        end
    end
endmodule