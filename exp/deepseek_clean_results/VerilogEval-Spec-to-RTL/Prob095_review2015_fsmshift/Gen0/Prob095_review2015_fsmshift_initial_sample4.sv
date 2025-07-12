module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    // Define states
    localparam RESET = 3'b000;
    localparam COUNT1 = 3'b001;
    localparam COUNT2 = 3'b010;
    localparam COUNT3 = 3'b011;
    localparam DONE = 3'b100;

    reg [2:0] current_state, next_state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= RESET;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            RESET:   next_state = COUNT1;
            COUNT1:  next_state = COUNT2;
            COUNT2:  next_state = COUNT3;
            COUNT3:  next_state = DONE;
            DONE:    next_state = DONE;
            default: next_state = RESET;
        endcase
    end

    // Output logic
    assign shift_ena = (current_state == RESET) || 
                      (current_state == COUNT1) || 
                      (current_state == COUNT2) || 
                      (current_state == COUNT3);

endmodule