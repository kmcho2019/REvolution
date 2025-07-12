module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // Binary state encoding
    parameter [1:0] IDLE    = 2'b00;
    parameter [1:0] GRANT_0 = 2'b01;
    parameter [1:0] GRANT_1 = 2'b10;
    parameter [1:0] GRANT_2 = 2'b11;

    reg [1:0] current_state, next_state;

    // Continuous assignments for next state logic
    assign next_state = 
        (current_state == IDLE) ? 
            (r[0] ? GRANT_0 : 
             r[1] ? GRANT_1 : 
             r[2] ? GRANT_2 : IDLE) :
        (current_state == GRANT_0) ? (r[0] ? GRANT_0 : IDLE) :
        (current_state == GRANT_1) ? (r[1] ? GRANT_1 : IDLE) :
        (current_state == GRANT_2) ? (r[2] ? GRANT_2 : IDLE) :
        IDLE;  // Default case

    // Sequential state register
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Output decoding logic
    always @(*) begin
        case (current_state)
            IDLE:    g = 3'b000;
            GRANT_0: g = 3'b001;
            GRANT_1: g = 3'b010;
            GRANT_2: g = 3'b100;
            default: g = 3'b000;
        endcase
    end

endmodule