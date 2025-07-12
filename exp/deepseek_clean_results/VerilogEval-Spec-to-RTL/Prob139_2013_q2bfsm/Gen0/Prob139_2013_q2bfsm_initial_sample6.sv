module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // Define states
    typedef enum {
        A,
        F_ON,
        MONITOR_X,
        G_ON,
        CHECK_Y,
        G_HOLD,
        G_LHOLD
    } state_t;

    reg [2:0] state, next_state;
    reg [1:0] x_history;
    reg [1:0] y_counter;

    // State transition and output logic
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            f <= 0;
            g <= 0;
            x_history <= 2'b00;
            y_counter <= 2'b00;
        end else begin
            state <= next_state;
            
            // Update x history shift register
            x_history <= {x_history[0], x};
            
            // Default outputs
            f <= 0;
            g <= 0;
            
            case (state)
                A: begin
                    next_state <= F_ON;
                end
                
                F_ON: begin
                    f <= 1;
                    next_state <= MONITOR_X;
                end
                
                MONITOR_X: begin
                    if (x_history == 2'b01 && x == 1'b1) begin
                        next_state <= G_ON;
                    end else begin
                        next_state <= MONITOR_X;
                    end
                end
                
                G_ON: begin
                    g <= 1;
                    y_counter <= 2'b00;
                    next_state <= CHECK_Y;
                end
                
                CHECK_Y: begin
                    g <= 1;
                    if (y) begin
                        next_state <= G_HOLD;
                    end else if (y_counter == 2'b01) begin
                        next_state <= G_LHOLD;
                    end else begin
                        y_counter <= y_counter + 1;
                        next_state <= CHECK_Y;
                    end
                end
                
                G_HOLD: begin
                    g <= 1;
                    next_state <= G_HOLD;
                end
                
                G_LHOLD: begin
                    g <= 0;
                    next_state <= G_LHOLD;
                end
                
                default: next_state <= A;
            endcase
        end
    end

endmodule