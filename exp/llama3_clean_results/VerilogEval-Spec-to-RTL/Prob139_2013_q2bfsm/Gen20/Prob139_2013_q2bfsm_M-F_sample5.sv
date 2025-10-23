module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);
    reg [2:0] state;
    reg [2:0] next_state;
    reg [1:0] x_count;
    reg [1:0] x_count_next;
    reg [1:0] y_count;
    reg [1:0] y_count_next;

    always @ (posedge clk) begin
        if (!resetn) begin
            state <= 0;
            f <= 0;
            g <= 0;
            x_count <= 0;
            y_count <= 0;
        end else begin
            state <= next_state;
            f <= (state == 1)? 1 : 0;
            g <= (state == 4)? 1 : (state == 5)? 0 : g;
            x_count <= x_count_next;
            y_count <= y_count_next;
        end
    end

    always @ (*) begin
        next_state = state;
        x_count_next = x_count;
        y_count_next = y_count;
        case (state)
            0: begin
                next_state = 1;
            end
            1: begin
                next_state = 2;
            end
            2: begin
                if (x) begin
                    if (x_count == 0) begin
                        x_count_next = 1;
                    end else if (x_count == 2) begin
                        next_state = 3;
                    end
                end else if (x_count == 1) begin
                    x_count_next = 2;
                end else begin
                    x_count_next = 0;
                end
            end
            3: begin
                g = 1;
                next_state = 4;
                if (y) begin
                    next_state = 4;
                end else begin
                    y_count_next = y_count + 1;
                    if (y_count < 2) begin
                        next_state = 3;
                    end else begin
                        next_state = 5;
                    end
                end
            end
            4: begin
                // Permanently set g to 1
            end
            5: begin
                // Permanently set g to 0
            end
        endcase
    end
endmodule