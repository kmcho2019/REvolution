module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    // One-hot encoded states
    localparam IDLE_BIT  = 3'b001;
    localparam BYTE2_BIT = 3'b010;
    localparam BYTE3_BIT = 3'b100;

    reg [2:0] state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE_BIT;
            done <= 1'b0;
        end else begin
            state <= next_state;
            // Assert done only when transitioning from BYTE3 state (message completed)
            done <= (state == BYTE3_BIT);
        end
    end

    always @(*) begin
        case (state)
            IDLE_BIT:  next_state = (in[3]) ? BYTE2_BIT : IDLE_BIT;
            BYTE2_BIT: next_state = BYTE3_BIT;
            BYTE3_BIT: next_state = IDLE_BIT;
            default:   next_state = IDLE_BIT;
        endcase
    end

endmodule