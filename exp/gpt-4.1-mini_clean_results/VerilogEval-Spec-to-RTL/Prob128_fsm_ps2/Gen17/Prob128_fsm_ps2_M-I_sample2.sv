module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // Define FSM states with one-hot encoding for clarity and potentially better PPA
    localparam IDLE  = 3'b001;
    localparam BYTE1 = 3'b010;
    localparam BYTE2 = 3'b100;

    reg [2:0] state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic and done pulse generation
    always @(*) begin
        done = 1'b0;
        case(state)
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
                // After receiving the third byte, signal done and go to IDLE
                done = 1'b1;
                next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule