module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Sequence detection module
reg seq_detected;
reg [1:0] x_seq;

always @ (posedge clk) begin
    if (!resetn) begin
        x_seq <= 2'b00;
        seq_detected <= 1'b0;
    end else begin
        case (x_seq)
            2'b00: begin
                if (x) x_seq <= 2'b01;
            end
            2'b01: begin
                if (!x) x_seq <= 2'b10;
                else x_seq <= 2'b00;
            end
            2'b10: begin
                if (x) begin
                    x_seq <= 2'b00;
                    seq_detected <= 1'b1;
                end else x_seq <= 2'b00;
            end
        endcase
    end
end

// f control module
reg f_trigger;
always @ (posedge clk) begin
    if (!resetn) begin
        f_trigger <= 1'b0;
        f <= 1'b0;
    end else begin
        if (seq_detected) begin
            f_trigger <= 1'b1;
            f <= 1'b1;
        end else if (f_trigger) begin
            f_trigger <= 1'b0;
            f <= 1'b0;
        end
    end
end

// g control module
reg g_trigger;
reg [1:0] y_count;
always @ (posedge clk) begin
    if (!resetn) begin
        g_trigger <= 1'b0;
        y_count <= 0;
        g <= 1'b0;
    end else begin
        if (f) begin
            g_trigger <= 1'b1;
            y_count <= 0;
        end else if (g_trigger) begin
            if (y) begin
                g_trigger <= 1'b0;
                g <= 1'b1;
            end else if (y_count < 2) begin
                y_count <= y_count + 1;
            end else begin
                g_trigger <= 1'b0;
                g <= 1'b0;
            end
        end
    end
end

endmodule