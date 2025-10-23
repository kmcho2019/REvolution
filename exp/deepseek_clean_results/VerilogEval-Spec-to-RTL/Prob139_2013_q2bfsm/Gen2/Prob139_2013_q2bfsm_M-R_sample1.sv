module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

    // State encoding
    localparam A = 3'd0;  // Initial/reset state
    localparam B = 3'd1;  // Pulse f=1
    localparam C = 3'd2;  // Wait for first 1 in x sequence
    localparam D = 3'd3;  // Wait for 0 in x sequence
    localparam E = 3'd4;  // Wait for second 1 in x sequence
    localparam F = 3'd5;  // Wait for y=1 (with timeout)
    localparam G = 3'd6;  // Permanent g=0 state

    reg [2:0] state;
    reg [1:0] timeout_counter;
    reg f_reg, g_reg;

    // Synchronous state transition and timeout counter
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            timeout_counter <= 2'b10;
            f_reg <= 1'b0;
            g_reg <= 1'b0;
        end else begin
            case (state)
                A: state <= B;
                B: state <= C;
                C: state <= x ? D : C;
                D: state <= x ? C : E;
                E: state <= x ? F : C;
                F: begin
                    if (y) begin
                        // Stay in F permanently
                    end else if (timeout_counter == 2'b00) begin
                        state <= G;
                    end
                    timeout_counter <= timeout_counter - (y ? 2'b00 : 2'b01);
                end
                G: begin end  // Stay in G permanently
                default: state <= A;
            endcase

            // Output registers
            f_reg <= (state == B);
            g_reg <= (state == F) || (state == G && y);
        end
    end

    // Output assignments
    assign f = f_reg;
    assign g = g_reg;

endmodule