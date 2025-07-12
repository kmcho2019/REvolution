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
    parameter F_ON = 3'b001;
    parameter MONITOR_X = 3'b010;
    parameter G_ON = 3'b011;
    parameter CHECK_Y = 3'b100;

    reg [2:0] current_state, next_state;
    reg [1:0] x_history;  // Stores last two x values
    reg [1:0] y_timer;    // Counts cycles waiting for y

    // State register
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            A: next_state = resetn ? F_ON : A;
            F_ON: next_state = MONITOR_X;
            MONITOR_X: 
                if (x_history == 2'b01 && x == 1'b1) 
                    next_state = G_ON;
                else 
                    next_state = MONITOR_X;
            G_ON: next_state = CHECK_Y;
            CHECK_Y: 
                if (y == 1'b1 || y_timer == 2'b10) 
                    next_state = CHECK_Y;  // Stay permanently
                else 
                    next_state = CHECK_Y;
            default: next_state = A;
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (!resetn) begin
            f <= 1'b0;
            g <= 1'b0;
            x_history <= 2'b00;
            y_timer <= 2'b00;
        end else begin
            // Update x history (shift register)
            x_history <= {x_history[0], x};

            // Output and timer logic
            case (current_state)
                A: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                F_ON: begin
                    f <= 1'b1;
                    g <= 1'b0;
                end
                MONITOR_X: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                G_ON: begin
                    f <= 1'b0;
                    g <= 1'b1;
                    y_timer <= 2'b00;
                end
                CHECK_Y: begin
                    f <= 1'b0;
                    if (y == 1'b1) begin
                        g <= 1'b1;  // Lock g permanently
                    end else if (y_timer == 2'b01) begin
                        g <= 1'b0;  // Timeout after 2 cycles
                    end
                    y_timer <= y_timer + 1'b1;
                end
            endcase
        end
    end

endmodule