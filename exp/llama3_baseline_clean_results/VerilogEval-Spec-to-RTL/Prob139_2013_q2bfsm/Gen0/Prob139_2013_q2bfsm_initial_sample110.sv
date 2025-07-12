module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state;

localparam A = 2'b00;
localparam SET_F = 2'b01;
localparam WAIT_SEQ = 2'b10;
localparam CHECK_Y = 2'b11;

reg [2:0] seq_count;
reg [1:0] y_count;

always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
        seq_count <= 0;
        y_count <= 0;
    end else begin
        case (state)
            A: begin
                state <= SET_F;
                f <= 0;
                g <= 0;
                seq_count <= 0;
                y_count <= 0;
            end
            SET_F: begin
                state <= WAIT_SEQ;
                f <= 1;
                g <= 0;
                seq_count <= 0;
            end
            WAIT_SEQ: begin
                f <= 0;
                if (seq_count == 3'b000 && x == 1) begin
                    seq_count <= seq_count + 1;
                end else if (seq_count == 3'b001 && x == 0) begin
                    seq_count <= seq_count + 1;
                end else if (seq_count == 3'b010 && x == 1) begin
                    state <= CHECK_Y;
                    seq_count <= 0;
                    g <= 1;
                end else begin
                    seq_count <= 0;
                end
            end
            CHECK_Y: begin
                if (y == 1) begin
                    y_count <= 2;
                end else if (y_count < 2) begin
                    y_count <= y_count + 1;
                end
                if (y_count == 2) begin
                    g <= 0;
                end
            end
        endcase
    end
end

endmodule