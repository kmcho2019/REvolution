module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

    // State encoding
    parameter A = 3'd0;  // Initial state
    parameter B = 3'd1;  // f pulse state
    parameter C = 3'd2;  // Pattern monitoring
    parameter D = 3'd3;  // y monitoring (g=1)
    parameter E = 3'd4;  // g=1 permanent
    parameter F = 3'd5;  // g=0 permanent

    reg [2:0] state, next_state;
    reg [2:0] x_shift;   // Shift register for x pattern
    reg [1:0] y_timer;   // Timer for y monitoring
    reg f_reg, g_reg;

    // State transition logic
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            x_shift <= 3'b000;
            y_timer <= 2'b00;
        end else begin
            state <= next_state;
            x_shift <= {x_shift[1:0], x};
            
            // Update y timer only in monitoring state
            if (state == D) begin
                y_timer <= y_timer + 1'b1;
            end else begin
                y_timer <= 2'b00;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            A: next_state = B;  // Always move to B after reset
            B: next_state = C;  // Single cycle f pulse
            C: begin
                if (x_shift == 3'b101) begin
                    next_state = D;  // Pattern detected
                end else begin
                    next_state = C;  // Keep monitoring
                end
            end
            D: begin
                if (y) begin
                    next_state = E;  // y detected
                end else if (y_timer == 2'b10) begin
                    next_state = F;  // Timeout
                end else begin
                    next_state = D;  // Keep monitoring
                end
            end
            E: next_state = E;  // Permanent states
            F: next_state = F;
            default: next_state = A;
        endcase
    end

    // Output logic (combinational)
    always @(*) begin
        case (state)
            B: begin
                f_reg = 1'b1;
                g_reg = 1'b0;
            end
            D: begin
                f_reg = 1'b0;
                g_reg = 1'b1;
            end
            E: begin
                f_reg = 1'b0;
                g_reg = 1'b1;
            end
            F: begin
                f_reg = 1'b0;
                g_reg = 1'b0;
            end
            default: begin
                f_reg = 1'b0;
                g_reg = 1'b0;
            end
        endcase
    end

    // Continuous assignments for outputs
    assign f = f_reg;
    assign g = g_reg;

endmodule