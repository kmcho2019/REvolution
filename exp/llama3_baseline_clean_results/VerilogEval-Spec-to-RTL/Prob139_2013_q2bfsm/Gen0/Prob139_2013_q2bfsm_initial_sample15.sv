module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

reg [2:0] state; // State register
reg [1:0] x_sequence; // Shift register for x sequence
reg [1:0] y_counter; // Counter for y
reg f_reg, g_reg; // Registers for f and g

// States
localparam A = 3'b000; // Reset state
localparam B = 3'b001; // State after reset, set f to 1
localparam C = 3'b010; // Monitor x sequence
localparam D = 3'b011; // Set g to 1, monitor y
localparam E = 3'b100; // g = 1 permanently
localparam F = 3'b101; // g = 0 permanently

always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        f_reg <= 0;
        g_reg <= 0;
        x_sequence <= 2'b00;
        y_counter <= 2'b00;
    end else begin
        case (state)
            A: begin
                state <= B;
                f_reg <= 1;
                g_reg <= 0;
            end
            B: begin
                state <= C;
                f_reg <= 0;
                g_reg <= 0;
                x_sequence <= {x_sequence[0], x};
            end
            C: begin
                x_sequence <= {x_sequence[0], x};
                if (x_sequence == 2'b101) begin
                    state <= D;
                    g_reg <= 1;
                    y_counter <= 2'b01;
                end
            end
            D: begin
                y_counter <= y_counter + 1;
                if (y) begin
                    state <= E;
                end else if (y_counter == 2'b10) begin
                    state <= F;
                    g_reg <= 0;
                end
            end
            E: begin
                // Do nothing, g = 1 permanently
            end
            F: begin
                // Do nothing, g = 0 permanently
            end
            default: state <= A;
        endcase
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule