module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // State encoding
    localparam IDLE      = 2'b00;
    localparam SEARCHING = 2'b01;
    localparam FLIPPING  = 2'b10;

    reg [1:0] state, next_state;

    // State transition with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                // After reset released, start SEARCHING
                next_state = SEARCHING;
            end
            SEARCHING: begin
                // Stay searching until first '1' found, then go to FLIPPING
                if (x == 1'b1)
                    next_state = FLIPPING;
                else
                    next_state = SEARCHING;
            end
            FLIPPING: begin
                // Once in FLIPPING, remain until reset
                next_state = FLIPPING;
            end
            default: next_state = IDLE;
        endcase
    end

    // Moore output logic depends only on current state and input
    always @(*) begin
        case (state)
            IDLE:      z = 1'b0;      // output zero during reset
            SEARCHING: z = x;         // copy bits until first '1'
            FLIPPING:  z = ~x;        // invert bits after first '1'
            default:   z = 1'b0;
        endcase
    end

endmodule