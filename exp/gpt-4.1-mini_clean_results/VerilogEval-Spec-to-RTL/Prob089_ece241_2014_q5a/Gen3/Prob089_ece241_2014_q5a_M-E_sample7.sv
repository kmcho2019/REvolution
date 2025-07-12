module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam WAIT_START   = 2'b00;
    localparam PASS_THROUGH = 2'b01;
    localparam INVERT_BITS  = 2'b10;

    reg [1:0] state, next_state;
    reg       next_z;

    // Asynchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WAIT_START;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;
        end
    end

    // Next state and output logic (Moore FSM)
    always @(*) begin
        case (state)
            WAIT_START: begin
                // Wait for reset release to start
                next_state = PASS_THROUGH;
                next_z = 1'b0; // output 0 while waiting
            end

            PASS_THROUGH: begin
                // Output input bit directly, copy mode
                next_z = x;
                if (x == 1'b1)
                    next_state = INVERT_BITS; // First 1 found, start invert
                else
                    next_state = PASS_THROUGH;
            end

            INVERT_BITS: begin
                // After first 1, output inverted bits
                next_z = ~x;
                next_state = INVERT_BITS;
            end

            default: begin
                next_state = WAIT_START;
                next_z = 1'b0;
            end
        endcase
    end

endmodule