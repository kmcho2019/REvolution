module TopModule (
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

reg [2:0] state; // 3-bit state variable
reg [2:0] nextState; // next state variable
reg f_reg; // register for output f
reg g_reg; // register for output g
reg [2:0] x_count; // counter for x input
reg [1:0] y_count; // counter for y input

// state encoding
localparam STATE_A = 3'b000;
localparam STATE_B = 3'b001;
localparam STATE_C = 3'b010;
localparam STATE_D = 3'b011;
localparam STATE_E = 3'b100;
localparam STATE_F = 3'b101;
localparam STATE_G = 3'b110;

always @(*) begin
    // default values
    f = 0;
    g = 0;
    nextState = state;

    case (state)
        STATE_A: begin
            if (~resetn) begin
                nextState = STATE_A;
            end else begin
                nextState = STATE_B;
            end
        end

        STATE_B: begin
            f = 1;
            nextState = STATE_C;
        end

        STATE_C: begin
            if (x_count == 3'b101) begin
                nextState = STATE_D;
            end else begin
                nextState = STATE_C;
            end
        end

        STATE_D: begin
            g = 1;
            nextState = STATE_E;
        end

        STATE_E: begin
            nextState = STATE_F;
        end

        STATE_F: begin
            if (y) begin
                nextState = STATE_F;
            end else if (y_count == 2'b11) begin
                nextState = STATE_G;
            end else begin
                nextState = STATE_F;
            end
        end

        STATE_G: begin
            g = 0;
            nextState = STATE_G;
        end

        default: begin
            nextState = STATE_A;
        end
    endcase
end

always @(posedge clk) begin
    if (~resetn) begin
        state <= STATE_A;
        f_reg <= 0;
        g_reg <= 0;
        x_count <= 0;
        y_count <= 0;
    end else begin
        state <= nextState;
        f_reg <= f;
        g_reg <= g;
        if (state == STATE_C) begin
            if (x) begin
                x_count <= {x_count[1:0], 1'b1};
            end else begin
                x_count <= {x_count[1:0], 1'b0};
            end
        end else begin
            x_count <= 0;
        end

        if (state == STATE_F) begin
            if (~y) begin
                y_count <= y_count + 1'b1;
            end else begin
                y_count <= 0;
            end
        end else begin
            y_count <= 0;
        end
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule