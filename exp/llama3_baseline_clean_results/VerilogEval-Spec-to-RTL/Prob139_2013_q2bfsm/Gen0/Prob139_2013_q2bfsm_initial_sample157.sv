module TopModule(
    input        clk,
    input        resetn,
    input        x,
    input        y,
    output       f,
    output       g
);

// Define states
enum {A, B, C1, C2, C3, D1, D2, D} state, next_state;

// Define variables to track x sequence and y timeout
reg [1:0] x_seq;
reg [1:0] y_count;

always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
        x_seq <= 0;
        y_count <= 0;
    end else begin
        case (state)
            A: begin
                if (resetn) begin
                    state <= B;
                end
                f <= 0;
                g <= 0;
            end
            B: begin
                state <= C1;
                f <= 1;
                g <= 0;
            end
            C1: begin
                if (x) begin
                    x_seq[0] <= 1;
                    state <= C2;
                end else begin
                    x_seq <= 0;
                    state <= C1;
                end
                f <= 0;
                g <= 0;
            end
            C2: begin
                if (!x) begin
                    x_seq[1] <= 1;
                    state <= C3;
                end else begin
                    x_seq <= 0;
                    state <= C1;
                end
                f <= 0;
                g <= 0;
            end
            C3: begin
                if (x) begin
                    state <= D1;
                    g <= 1;
                end else begin
                    x_seq <= 0;
                    state <= C1;
                end
                f <= 0;
            end
            D1: begin
                state <= D2;
                y_count <= 1;
            end
            D2: begin
                if (y) begin
                    state <= D;
                end else if (y_count == 1) begin
                    state <= D2;
                    y_count <= 2;
                end else begin
                    state <= D;
                    g <= 0;
                end
            end
            D: begin
                if (y) begin
                    state <= D;
                end else begin
                    state <= D;
                end
            end
            default: begin
                state <= A;
            end
        endcase
    end
end

endmodule