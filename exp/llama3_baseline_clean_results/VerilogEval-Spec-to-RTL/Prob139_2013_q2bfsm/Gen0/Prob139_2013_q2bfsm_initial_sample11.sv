module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// Define states
localparam [2:0] A = 3'b000; // Initial state, reset state
localparam [2:0] B = 3'b001; // State after reset is de-asserted
localparam [2:0] C = 3'b010; // Monitor x input for the sequence 1, 0, 1
localparam [2:0] D = 3'b011; // Set output g to 1 and monitor y input
localparam [2:0] E = 3'b100; // Output g remains 1 permanently
localparam [2:0] F = 3'b101; // Output g remains 0 permanently

// State register
reg [2:0] state;
reg [2:0] nextState;

// x sequence counter
reg [1:0] x_seq;

// y timer
reg [1:0] y_timer;

// Output registers
reg f_reg;
reg g_reg;

// Combinational logic
always @(*) begin
    case (state)
        A: begin
            f_reg = 0;
            g_reg = 0;
            if (~resetn) begin
                nextState = A;
            end else begin
                nextState = B;
            end
        end
        B: begin
            f_reg = 1;
            g_reg = 0;
            nextState = C;
        end
        C: begin
            f_reg = 0;
            g_reg = 0;
            if (x_seq == 2'b11) begin
                nextState = D;
                x_seq = 0;
            end else begin
                case (x)
                    1'b1: begin
                        x_seq = {x_seq[0], 1'b1};
                    end
                    1'b0: begin
                        x_seq = {x_seq[0], 1'b0};
                    end
                endcase
                nextState = C;
            end
        end
        D: begin
            f_reg = 0;
            g_reg = 1;
            if (y_timer == 2'b11) begin
                if (y) begin
                    nextState = E;
                end else begin
                    nextState = F;
                end
            end else begin
                y_timer = y_timer + 1;
                nextState = D;
            end
        end
        E: begin
            f_reg = 0;
            g_reg = 1;
            nextState = E;
        end
        F: begin
            f_reg = 0;
            g_reg = 0;
            nextState = F;
        end
        default: begin
            f_reg = 0;
            g_reg = 0;
            nextState = A;
        end
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if (~resetn) begin
        state <= A;
        x_seq <= 0;
        y_timer <= 0;
        f <= 0;
        g <= 0;
    end else begin
        state <= nextState;
        if (state == C) begin
            if (x == 1'b1) begin
                x_seq <= {x_seq[0], 1'b1};
            end else if (x == 1'b0) begin
                x_seq <= {x_seq[0], 1'b0};
            end
        end else if (state == D) begin
            y_timer <= y_timer + 1;
        end else begin
            x_seq <= 0;
            y_timer <= 0;
        end
        f <= f_reg;
        g <= g_reg;
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule