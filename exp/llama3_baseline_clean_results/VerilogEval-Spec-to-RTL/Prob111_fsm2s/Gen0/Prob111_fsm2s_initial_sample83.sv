module TopModule(clk, reset, j, k, out);
    input clk, reset, j, k;
    output out;
    reg out;
    reg [1:0] current_state, next_state;

    // Define states
    parameter OFF = 2'b00, ON = 2'b01;

    // Output logic
    always @(current_state) begin
        case (current_state)
            OFF: out = 1'b0;
            ON: out = 1'b1;
            default: out = 1'bx; // Default to avoid latch inference
        endcase
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            OFF: begin
                if (reset) next_state = OFF;
                else if (j) next_state = ON;
                else next_state = OFF;
            end
            ON: begin
                if (reset) next_state = OFF;
                else if (k) next_state = OFF;
                else next_state = ON;
            end
            default: next_state = 2'bx; // Default to avoid latch inference
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset) current_state <= OFF;
        else current_state <= next_state;
    end

    initial begin
        current_state = OFF;
    end

endmodule