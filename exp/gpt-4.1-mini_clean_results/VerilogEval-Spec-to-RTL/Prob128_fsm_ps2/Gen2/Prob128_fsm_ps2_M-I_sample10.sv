module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    // One-hot encoding states for simpler logic and potentially better timing
    localparam IDLE  = 3'b001;
    localparam BYTE2 = 3'b010;
    localparam BYTE3 = 3'b100;

    reg [2:0] state, next_state;
    reg [7:0] in_d; // Registered input to reduce glitches and improve timing

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done  <= 1'b0;
            in_d  <= 8'b0;
        end else begin
            state <= next_state;
            in_d  <= in;
            // done asserted only one cycle after receiving the third byte
            done <= (state == BYTE3);
        end
    end

    // Next state logic based on current state and registered input
    always @(*) begin
        case(state)
            IDLE:  next_state = (in_d[3]) ? BYTE2 : IDLE;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule