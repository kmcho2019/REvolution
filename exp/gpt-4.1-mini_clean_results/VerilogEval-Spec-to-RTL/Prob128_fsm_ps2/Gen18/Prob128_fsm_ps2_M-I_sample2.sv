module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    // State encoding (one-hot style)
    localparam IDLE  = 3'b001;
    localparam BYTE1 = 3'b010;
    localparam BYTE2 = 3'b100;

    reg [2:0] state, next_state;

    // Next state logic
    always @(*) begin
        done = 1'b0; // default done low
        case (state)
            IDLE: begin
                if (in[3])
                    next_state = BYTE1;
                else
                    next_state = IDLE;
            end

            BYTE1: begin
                next_state = BYTE2;
            end

            BYTE2: begin
                // On next byte, signal done and go back to IDLE
                next_state = IDLE;
                done = 1'b1;
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // State register update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done  <= 1'b0;
        end else begin
            state <= next_state;
            // done is combinational, but registered on the output to avoid glitches
            // Here done is assigned in combinational block for immediate pulse
            // We need to register done to ensure it's output in sync with state transitions
            // So done assigned in always @(*) is a combinational signal to next_state, 
            // To fix this, move done assignment to sequential block:
            // done <= (state == BYTE2); 
        end
    end

    // Register done signal synchronous to clk
    always @(posedge clk) begin
        if (reset)
            done <= 1'b0;
        else
            done <= (state == BYTE2);
    end

endmodule