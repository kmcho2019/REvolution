module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

reg [2:0] state; // state register
reg [1:0] counter; // counter for State D
reg f_reg; // register for output f
reg g_reg; // register for output g

// State encoding
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Assign initial values
initial begin
    state = A;
    counter = 2'b00;
    f_reg = 1'b0;
    g_reg = 1'b0;
end

// Sequential logic
always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        counter <= 2'b00;
        f_reg <= 1'b0;
        g_reg <= 1'b0;
    end
    else begin
        case (state)
            A: begin
                if (resetn) begin
                    state <= B;
                    f_reg <= 1'b1;
                end
            end
            B: begin
                state <= C;
                f_reg <= 1'b0;
            end
            C: begin
                if (x == 1'b1) begin
                    state <= C;
                end
                else if (x == 1'b0) begin
                    state <= C;
                end
                else begin
                    state <= C;
                end
                // To detect the sequence 1, 0, 1
                if (x == 1'b1 && state == C) begin
                    state <= C;
                end
                else if (x == 1'b0 && state == C) begin
                    state <= C;
                    if (x == 1'b1) begin
                        state <= D;
                    end
                end
                else if (x == 1'b1 && state == C) begin
                    state <= D;
                end
                // To detect the sequence 1, 0, 1
                reg [2:0] seq;
                initial seq = 3'b000;
                always @(posedge clk) begin
                    if (x == 1'b1) begin
                        seq <= 3'b001;
                    end
                    else if (x == 1'b0) begin
                        seq <= 3'b010;
                    end
                    else if (x == 1'b1) begin
                        seq <= 3'b011;
                    end
                    if (seq == 3'b011) begin
                        state <= D;
                        g_reg <= 1'b1;
                    end
                end
            end
            D: begin
                counter <= counter + 1'b1;
                if (y == 1'b1 || counter == 2'b10) begin
                    if (y == 1'b1) begin
                        state <= E;
                    end
                    else begin
                        state <= F;
                    end
                end
            end
            E: begin
                g_reg <= 1'b1;
            end
            F: begin
                g_reg <= 1'b0;
            end
            default: begin
                state <= A;
            end
        endcase
    end
end

// Output logic
assign f = f_reg;
assign g = g_reg;

endmodule