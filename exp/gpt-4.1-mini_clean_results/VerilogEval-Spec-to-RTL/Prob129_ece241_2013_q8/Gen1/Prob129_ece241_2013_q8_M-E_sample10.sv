module TopModule(
    input  wire clk,
    input  wire aresetn,
    input  wire x,
    output reg  z
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam ONE  = 2'b01;
    localparam TEN  = 2'b10;

    reg [1:0] state, next_state;

    // Next state and output logic (combinational)
    always @(*) begin
        // Default assignments
        next_state = IDLE;
        z = 1'b0;

        case (state)
            IDLE: begin
                if (x)
                    next_state = ONE;
                else
                    next_state = IDLE;
            end

            ONE: begin
                if (x)
                    next_state = ONE;
                else
                    next_state = TEN;
            end

            TEN: begin
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