module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // State encoding
    localparam IDLE  = 2'b00;
    localparam COPY  = 2'b01;
    localparam INVERT= 2'b10;

    reg [1:0] state, next_state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                // Start processing when reset released
                next_state = COPY;
            end
            COPY: begin
                // Copy bits until first '1' seen, then invert rest
                if (x == 1'b1)
                    next_state = INVERT;
                else
                    next_state = COPY;
            end
            INVERT: begin
                // Stay in invert state
                next_state = INVERT;
            end
            default: next_state = IDLE;
        endcase
    end

    // Moore output logic: depends on state and input x
    always @(*) begin
        case(state)
            IDLE:    z = 1'b0;       // Output zero during reset/inactive
            COPY:    z = x;          // Copy input bit
            INVERT:  z = ~x;         // Invert input bit
            default: z = 1'b0;
        endcase
    end

endmodule