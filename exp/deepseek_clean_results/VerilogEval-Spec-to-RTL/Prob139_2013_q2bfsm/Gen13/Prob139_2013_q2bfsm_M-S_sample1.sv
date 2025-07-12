module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

localparam A = 0, B = 1, C = 2, D = 3, E = 4, F = 5, G = 6, H = 7;
reg [2:0] state;
reg [1:0] x_history;  // Tracks last two x values
reg y_timeout;         // Tracks if we've waited two cycles for y

always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        x_history <= 2'b00;
        y_timeout <= 0;
    end else begin
        case (state)
            A: state <= B;
            B: state <= C;
            C: if (x) state <= D;
            D: begin
                x_history <= {x_history[0], x};
                if (!x) state <= E;
                else state <= C;
            end
            E: begin
                x_history <= {x_history[0], x};
                if (x_history == 2'b01 && x) state <= F;
                else if (x) state <= D;
                else state <= C;
            end
            F: begin
                if (y) state <= G;
                else if (y_timeout) state <= H;
                y_timeout <= 1;
            end
            default: ; // G and H stay until reset
        endcase
    end
end

assign f = (state == B);
assign g = (state == F) || (state == G);

endmodule