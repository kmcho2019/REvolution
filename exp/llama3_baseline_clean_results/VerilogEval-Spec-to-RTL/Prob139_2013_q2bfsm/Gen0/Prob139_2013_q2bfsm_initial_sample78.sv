module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state; // State variable
reg [1:0] count_x; // Counter for state C
reg [1:0] count_y; // Counter for state D

// Define states
localparam A = 3'b001;
localparam B = 3'b010;
localparam C = 3'b011;
localparam D = 3'b100;
localparam E = 3'b101;
localparam F = 3'b110;

always @(posedge clk) begin
    if (~resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
        count_x <= 0;
        count_y <= 0;
    end else begin
        case (state)
            A: begin
                state <= B;
                f <= 1;
                g <= 0;
                count_x <= 0;
                count_y <= 0;
            end
            B: begin
                state <= C;
                f <= 0;
            end
            C: begin
                case (count_x)
                    0: begin
                        if (x) count_x <= 1;
                    end
                    1: begin
                        if (~x) count_x <= 2;
                        else count_x <= 1;
                    end
                    2: begin
                        if (x) begin
                            state <= D;
                            g <= 1;
                            count_x <= 0;
                            count_y <= 1;
                        end else count_x <= 2;
                    end
                endcase
            end
            D: begin
                count_y <= count_y + 1;
                if (y) state <= E;
                else if (count_y == 2) state <= F;
            end
            E: begin
                // Do nothing
            end
            F: begin
                // Do nothing
            end
        endcase
    end
end

endmodule