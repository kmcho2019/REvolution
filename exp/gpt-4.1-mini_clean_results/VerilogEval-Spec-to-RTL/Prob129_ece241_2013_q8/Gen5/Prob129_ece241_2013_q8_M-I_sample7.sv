module TopModule(
    input  wire clk,
    input  wire aresetn,
    input  wire x,
    output reg  z
);

    // One-hot state encoding
    localparam IDLE = 3'b001;
    localparam ONE  = 3'b010;
    localparam TEN  = 3'b100;

    reg [2:0] state, next_state;

    // Next state and output logic (combinational)
    always @(*) begin
        // Default assignments
        next_state = IDLE;
        z = 1'b0;

        case (1'b1) // one-hot encoded state decoding
            state[0]: begin // IDLE state
                if (x)
                    next_state = ONE;
                else
                    next_state = IDLE;
            end

            state[1]: begin // ONE state
                if (x)
                    next_state = ONE;
                else
                    next_state = TEN;
            end

            state[2]: begin // TEN state
                if (x) begin
                    next_state = ONE;
                    z = 1'b1; // "101" detected
                end else
                    next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // State register with async negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= IDLE;
        else
            state <= next_state;
    end

endmodule