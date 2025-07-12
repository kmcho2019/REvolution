module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

    // State encoding
    localparam A = 3'd0;  // Initial/reset state
    localparam B = 3'd1;  // Pulse f=1
    localparam C = 3'd2;  // Wait for first 1 in x sequence
    localparam D = 3'd3;  // Wait for 0 in x sequence
    localparam E = 3'd4;  // Wait for second 1 in x sequence
    localparam F = 3'd5;  // Wait for y=1 (with timeout)
    localparam G = 3'd6;  // Permanent g=0 state

    reg [2:0] state, next_state;
    reg [1:0] timeout_counter;
    reg g_reg;

    // State transition logic
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            timeout_counter <= 2'b10; // Initialize to 2 (for 2-cycle timeout)
            g_reg <= 1'b0;
        end else begin
            state <= next_state;
            
            // Timeout counter logic
            if (state == F && !y) begin
                timeout_counter <= timeout_counter - 1;
            end else if (state != F) begin
                timeout_counter <= 2'b10; // Reset counter when not in F
            end
            
            // Permanent g=1 when y is detected in F
            if (state == F && y) begin
                g_reg <= 1'b1;
            end else if (state == G) begin
                g_reg <= 1'b0;
            end else if (state == F && timeout_counter == 0) begin
                g_reg <= 1'b0;
            end else if (state == E && x) begin
                g_reg <= 1'b1; // Set g=1 when entering F
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            A: next_state = resetn ? B : A;
            B: next_state = C;
            C: next_state = x ? D : C;
            D: next_state = x ? C : E;
            E: next_state = x ? F : C;
            F: next_state = (y || timeout_counter == 0) ? F : F; // Stay until timeout or y=1
            G: next_state = G;
            default: next_state = A;
        end
    end

    // Output logic
    assign f = (state == B);
    assign g = (state == F) ? g_reg : 
               (state == G) ? 1'b0 : 
               1'b0;

endmodule