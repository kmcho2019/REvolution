module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);
    reg [1:0] state;
    reg [1:0] next_state;
    reg [1:0] x_seq_count;
    reg [1:0] x_seq_count_next;
    reg [1:0] y_count;
    reg [1:0] y_count_next;

    always @ (posedge clk) begin
        if (!resetn) begin
            state <= 0;
            f <= 0;
            g <= 0;
            x_seq_count <= 0;
            y_count <= 0;
        end else begin
            state <= next_state;
            f <= (state == 1)? 1 : 0;
            g <= (state == 3 && y_count <= 2 && y)? 1 : 
                  (state == 3 && y_count > 2)? 0 : 
                  (state == 3 && y_count <= 2 && y_count != 0)? 1 : g;
            x_seq_count <= x_seq_count_next;
            y_count <= y_count_next;
        end
    end

    always @ (*) begin
        next_state = state;
        x_seq_count_next = x_seq_count;
        y_count_next = y_count;
        case (state)
            0: begin
                if (!resetn) begin
                    next_state = 0;
                end else begin
                    next_state = 1;
                end
            end
            1: begin
                next_state = 2;
            end
            2: begin
                if (x) begin
                    if (x_seq_count == 0) begin
                        x_seq_count_next = 1;
                    end else if (x_seq_count == 2) begin
                        next_state = 3;
                    end
                end else if (x_seq_count == 1) begin
                    x_seq_count_next = 2;
                end else begin
                    x_seq_count_next = 0;
                end
            end
            3: begin
                if (y) begin
                    g <= 1;
                    y_count_next = 0;
                end else if (y_count < 2) begin
                    y_count_next = y_count + 1;
                end else begin
                    g <= 0;
                end
            end
        endcase
    end
endmodule