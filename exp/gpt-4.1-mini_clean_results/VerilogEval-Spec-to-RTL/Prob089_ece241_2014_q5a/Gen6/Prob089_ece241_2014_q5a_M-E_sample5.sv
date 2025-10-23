module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam PASS = 2'b01;
    localparam INVERT = 2'b10;

    reg [1:0] state, next_state;
    reg       next_z;

    // Combinational logic: next state and output
    always @(*) begin
        // Default assignments
        next_state = state;
        next_z = 1'b0;

        case(state)
            IDLE: begin
                next_z = 1'b0; // output zero while waiting
                if (x == 1'b1) begin
                    next_state = PASS;
                    next_z = 1'b1; // first '1' bit output as-is
                end
            end

            PASS: begin
                next_z = x; // output input bit as-is
                if (x == 1'b1)
                    next_state = INVERT; // after first '1', go to invert
            end

            INVERT: begin
                next_z = ~x; // invert input bit
                // stay in INVERT indefinitely
            end

            default: begin
                next_state = IDLE;
                next_z = 1'b0;
            end
        endcase
    end

    // Sequential logic: state and output registers with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;
        end
    end

endmodule