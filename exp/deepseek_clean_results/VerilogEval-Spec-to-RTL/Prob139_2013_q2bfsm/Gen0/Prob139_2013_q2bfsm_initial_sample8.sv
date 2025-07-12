module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // Define states
    parameter A = 3'b000;
    parameter B = 3'b001;
    parameter C = 3'b010;
    parameter D = 3'b011;
    parameter E = 3'b100;

    reg [2:0] current_state, next_state;
    reg [2:0] x_history;  // Shift register to track last 3 x values
    reg [1:0] y_counter;  // Counter for y monitoring in state D

    // State transition logic
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= A;
            x_history <= 3'b000;
            y_counter <= 2'b00;
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            current_state <= next_state;
            
            // Update x history shift register in state C
            if (current_state == C) begin
                x_history <= {x_history[1:0], x};
            end
            
            // Update y counter in state D
            if (current_state == D) begin
                if (y_counter < 2'b10) begin
                    y_counter <= y_counter + 1'b1;
                end
            end
            
            // Output logic
            case (current_state)
                A: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                B: begin
                    f <= 1'b1;
                    g <= 1'b0;
                end
                C: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                D: begin
                    f <= 1'b0;
                    g <= 1'b1;
                end
                E: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            A: next_state = resetn ? B : A;
            B: next_state = C;
            C: next_state = (x_history == 3'b101) ? D : C;
            D: begin
                if (y == 1'b1) begin
                    next_state = D;
                end else if (y_counter == 2'b10) begin
                    next_state = E;
                end else begin
                    next_state = D;
                end
            end
            E: next_state = E;
            default: next_state = A;
        endcase
    end

endmodule