module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

reg [2:0] state; // 0: A, 1: B, 2: C, 3: D, 4: E, 5: F
reg f_out;
reg g_out;
reg [1:0] x_sequence;
reg [1:0] y_timer;

always @(posedge clk) begin
    if (!resetn) begin
        state <= 0; // State A
        f_out <= 0;
        g_out <= 0;
        x_sequence <= 0;
        y_timer <= 0;
    end else begin
        case (state)
            0: begin // State A
                state <= 1; // Move to State B
                f_out <= 1;
            end
            1: begin // State B
                state <= 2; // Move to State C
                f_out <= 0;
            end
            2: begin // State C
                if (x_sequence == 2'b00) begin
                    if (x) begin
                        x_sequence <= 2'b01;
                    end
                end else if (x_sequence == 2'b01) begin
                    if (!x) begin
                        x_sequence <= 2'b10;
                    end else begin
                        x_sequence <= 2'b00;
                    end
                end else if (x_sequence == 2'b10) begin
                    if (x) begin
                        x_sequence <= 2'b11;
                    end else begin
                        x_sequence <= 2'b00;
                    end
                end else if (x_sequence == 2'b11) begin
                    state <= 3; // Move to State D
                    g_out <= 1;
                    y_timer <= 1;
                    x_sequence <= 0;
                end
            end
            3: begin // State D
                if (y) begin
                    state <= 4; // Move to State E
                    y_timer <= 0;
                end else begin
                    y_timer <= y_timer + 1;
                    if (y_timer > 2) begin
                        state <= 5; // Move to State F
                        g_out <= 0;
                    end
                end
            end
            4: begin // State E
                // Maintain g = 1 permanently
            end
            5: begin // State F
                // Maintain g = 0 permanently
            end
        endcase
    end
end

assign f = f_out;
assign g = g_out;

endmodule