module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

// Define states
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

reg [2:0] current_state;
reg [2:0] next_state;
reg f_reg, g_reg;

// Sequential logic
always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        current_state <= A;
        f_reg <= 0;
        g_reg <= 0;
    end else begin
        current_state <= next_state;
        f_reg <= 0;
        g_reg <= g_reg;
    end
end

// Combinational logic
always @(*) begin
    case (current_state)
        A: begin
            if (resetn) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        B: begin
            next_state = C;
            f_reg = 1;
        end
        C: begin
            static reg [1:0] x_count;
            if (x) begin
                x_count = {x_count[0], 1'b1};
            end else begin
                x_count = {x_count[0], 1'b0};
            end
            if (x_count == 2'b101) begin
                next_state = D;
                x_count = 0;
            end else begin
                next_state = C;
            end
        end
        D: begin
            static reg [1:0] y_count;
            g_reg = 1;
            if (y) begin
                next_state = E;
                y_count = 0;
            end else begin
                y_count = y_count + 1;
                if (y_count == 2) begin
                    next_state = F;
                end else begin
                    next_state = D;
                end
            end
        end
        E: begin
            next_state = E;
        end
        F: begin
            g_reg = 0;
            next_state = F;
        end
        default: next_state = A;
    endcase
end

assign f = f_reg;
assign g = g_reg;

endmodule