module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

    reg [2:0] state;
    reg [1:0] counter;
    reg f_reg;
    reg g_reg;

    // State definitions
    localparam A = 3'b000;
    localparam B = 3'b001;
    localparam C = 3'b010;
    localparam D = 3'b011;
    localparam E = 3'b100;
    localparam F = 3'b101;

    always @ (posedge clk) begin
        if (!resetn) begin
            state <= A;
            f_reg <= 0;
            g_reg <= 0;
            counter <= 0;
        end else begin
            case (state)
                A: begin
                    if (resetn) begin
                        state <= B;
                    end
                    f_reg <= 0;
                    g_reg <= 0;
                end
                B: begin
                    state <= C;
                    f_reg <= 1;
                    g_reg <= 0;
                end
                C: begin
                    f_reg <= 0;
                    if (x) begin
                        counter[0] <= 1;
                    end else if (counter[0] == 1'b1) begin
                        counter[1] <= 1;
                    end else if (counter[1] == 1'b1 && !x) begin
                        counter[2] <= 1;
                    end else if (counter[2] == 1'b1 && x) begin
                        state <= D;
                        counter <= 0;
                    end
                    g_reg <= 0;
                end
                D: begin
                    g_reg <= 1;
                    counter <= counter + 1;
                    if (y) begin
                        state <= E;
                    end else if (counter == 2'b10) begin
                        state <= F;
                    end
                end
                E: begin
                    g_reg <= 1;
                end
                F: begin
                    g_reg <= 0;
                end
            endcase
        end
    end

    assign f = f_reg;
    assign g = g_reg;

endmodule