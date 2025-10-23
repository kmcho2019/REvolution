module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] main_state;
reg [1:0] seq_count;
reg [1:0] y_timer;
reg next_main_state;
reg next_seq_count;
reg next_y_timer;
reg next_f;
reg next_g;

always @ (posedge clk) begin
    if (!resetn) begin
        main_state <= 0;
        seq_count <= 0;
        y_timer <= 0;
        f <= 0;
        g <= 0;
    end else begin
        main_state <= next_main_state;
        seq_count <= next_seq_count;
        y_timer <= next_y_timer;
        f <= next_f;
        g <= next_g;
    end
end

always @ (*) begin
    case (main_state)
        0: begin // RESET
            next_main_state = 1;
            next_seq_count = 0;
            next_y_timer = 0;
            next_f = 0;
            next_g = 0;
        end
        1: begin // INIT
            next_main_state = 2;
            next_seq_count = 0;
            next_y_timer = 0;
            next_f = 1;
            next_g = 0;
        end
        2: begin // SEQ_DET
            if (x == (seq_count % 3 == 0 || seq_count % 3 == 2)) begin
                next_seq_count = seq_count + 1;
                if (seq_count == 3) begin
                    next_main_state = 3;
                    next_y_timer = 0;
                end else begin
                    next_main_state = 2;
                end
            end else begin
                next_seq_count = 0;
                next_main_state = 2;
            end
            next_y_timer = 0;
            next_f = 0;
            next_g = 0;
        end
        3: begin // WAIT_Y
            if (y) begin
                next_main_state = 3;
                next_g = 1;
            end else if (y_timer < 2) begin
                next_main_state = 3;
                next_y_timer = y_timer + 1;
                next_g = 0;
            end else begin
                next_main_state = 3;
                next_g = 0;
            end
            next_f = 0;
            next_seq_count = 0;
        end
    endcase
end

endmodule