module TopModule (
    input  wire clk,
    input  wire aresetn,
    input  wire x,
    output reg  z
);

    // One-hot encoded states
    localparam IDLE = 3'b001;
    localparam GOT1 = 3'b010;
    localparam GOT10 = 3'b100;

    reg [2:0] state, next_state;

    // Next state and output combinational logic
    always @(*) begin
        // Defaults
        next_state = IDLE;
        z = 1'b0;

        case (state)
            IDLE: begin
                if (x)
                    next_state = GOT1;
                else
                    next_state = IDLE;
            end

            GOT1: begin
                if (x)
                    next_state = GOT1;
                else
                    next_state = GOT10;
            end

            GOT10: begin
                if (x) begin
                    next_state = GOT1;
                    z = 1'b1; // pattern "101" detected here (Mealy output)
                end else
                    next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
                z = 1'b0;
            end
        endcase
    end

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= IDLE;
        else
            state <= next_state;
    end

endmodule