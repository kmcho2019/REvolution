module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    // Define states with explicit binary encoding
    localparam [1:0] 
        RESET  = 2'b00,
        COUNT1 = 2'b01,
        COUNT2 = 2'b10,
        COUNT3 = 2'b11,
        DONE   = 2'b00; // Same as RESET but distinguished by context

    // State registers
    reg [1:0] current_state, next_state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= RESET;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic with default assignment
    always @(*) begin
        next_state = DONE; // Default to done state
        case (current_state)
            RESET:   next_state = COUNT1;
            COUNT1:  next_state = COUNT2;
            COUNT2:  next_state = COUNT3;
            COUNT3:  next_state = DONE;
            DONE:    next_state = DONE;
        endcase
    end

    // Output logic - active for all states except DONE
    assign shift_ena = (current_state != DONE) || reset;

endmodule