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

always @ (posedge clk) begin
    if (!resetn) begin
        main_state <= 0;
        seq_count <= 0;
        y_timer <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (main_state)
            0: begin // RESET
                main_state <= 1;
            end
            1: begin // INIT
                f <= 1;
                main_state <= 2;
            end
            2: begin // SEQ_DET
                if (x == (seq_count % 3 == 0 || seq_count % 3 == 2)) begin
                    seq_count <= seq_count + 1;
                    if (seq_count == 3) begin
                        main_state <= 3;
                        y_timer <= 0;
                    end
                end else begin
                    seq_count <= 0;
                end
            end
            3: begin // WAIT_Y
                if (y) begin
                    g <= 1;
                    main_state <= 3;
                end else if (y_timer < 2) begin
                    y_timer <= y_timer + 1;
                end else begin
                    g <= 0;
                end
            end
        endcase
        if (main_state != 1) begin
            f <= 0;
        end
    end
end

endmodule