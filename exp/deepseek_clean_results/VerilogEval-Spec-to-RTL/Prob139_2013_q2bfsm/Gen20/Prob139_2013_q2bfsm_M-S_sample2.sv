module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// FSM states
localparam A = 0, B = 1, C = 2, D = 3, E = 4, F = 5;
reg [2:0] state;

// Pattern detection shift register
reg [2:0] x_shift;

// Timeout counter
reg timeout;

always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        x_shift <= 3'b0;
        timeout <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            A: begin
                state <= B;
                f <= 0;
                g <= 0;
            end
            B: begin
                state <= C;
                f <= 1;
            end
            C: begin
                f <= 0;
                x_shift <= {x_shift[1:0], x};
                
                if (x_shift == 3'b101) begin
                    state <= D;
                    g <= 1;
                    timeout <= 0;
                end
            end
            D: begin
                if (y) begin
                    state <= E;
                end else if (timeout) begin
                    state <= F;
                    g <= 0;
                end else begin
                    timeout <= 1;
                end
            end
            E: g <= 1;  // Hold permanently
            F: g <= 0;  // Hold permanently
        endcase
    end
end

endmodule