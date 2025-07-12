module sequence_detector (
    input  wire clk,
    input  wire rst_n,          // Active low reset (renamed to match testbench)
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding (3 bits for clarity)
    localparam IDLE = 3'd0;  // No bits matched
    localparam S1   = 3'd1;  // matched '1'
    localparam S2   = 3'd2;  // matched '10'
    localparam S3   = 3'd3;  // matched '100'
    localparam S4   = 3'd4;  // matched '1001' (output state)

    reg [2:0] state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            S1: begin
                if (data_in == 1'b0)
                    next_state = S2;
                else
                    next_state = S1;
            end
            S2: begin
                if (data_in == 1'b0)
                    next_state = S3;
                else
                    next_state = S1;
            end
            S3: begin
                if (data_in == 1'b1)
                    next_state = S4;
                else
                    next_state = IDLE;
            end
            S4: begin
                // After detection, move to S1 if data_in=1 (to allow overlapping sequences),
                // else to IDLE
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // State register (synchronous reset)
    always @(posedge clk) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Output logic: sequence_detected is high only in state S4
    always @(posedge clk) begin
        if (!rst_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S4);
    end

endmodule