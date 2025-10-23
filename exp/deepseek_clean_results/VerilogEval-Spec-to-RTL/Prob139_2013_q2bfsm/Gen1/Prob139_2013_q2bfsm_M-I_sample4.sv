module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding
    localparam A = 3'd0;  // Reset state
    localparam B = 3'd1;  // Initial state after reset (f=1)
    localparam C = 3'd2;  // Monitoring x for 1-0-1 pattern
    localparam D = 3'd3;  // g=1, monitoring y
    localparam E = 3'd4;  // g=1 permanently
    localparam F = 3'd5;  // g=0 permanently

    reg [2:0] current_state, next_state;
    reg [1:0] x_history;  // Stores last 2 x values (need only 2 for 1-0-1 detection)
    reg [1:0] y_timeout;  // Counter for y monitoring

    // Combined state transition and output logic
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= A;
            f <= 0;
            g <= 0;
            x_history <= 2'b00;
            y_timeout <= 2'b00;
        end else begin
            current_state <= next_state;
            
            // Update x history (only need last 2 values since we check current x)
            x_history <= {x_history[0], x};
            
            // Default outputs
            f <= 0;
            g <= 0;
            
            case (next_state)
                B: f <= 1;  // Set f=1 for one cycle
                
                C: begin
                    // Check for 1-0-1 pattern (x_history[1]=1, x_history[0]=0, current x=1)
                    if (x_history == 2'b10 && x) begin
                        g <= 1;
                    end
                end
                
                D: begin
                    g <= 1;
                    if (y) begin
                        y_timeout <= 2'b00;
                    end else begin
                        y_timeout <= y_timeout + 1;
                    end
                end
                
                E: g <= 1;
                
                F: g <= 0;
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            A: next_state = resetn ? B : A;
            B: next_state = C;
            C: begin
                // Check for 1-0-1 pattern
                if (x_history == 2'b10 && x) begin
                    next_state = D;
                end else begin
                    next_state = C;
                end
            end
            D: begin
                if (y) begin
                    next_state = E;
                end else if (y_timeout == 2'b10) begin
                    next_state = F;
                end else begin
                    next_state = D;
                end
            end
            E: next_state = E;
            F: next_state = F;
            default: next_state = A;
        endcase
    end

endmodule