module TopModule(
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // State encoding (one-hot style with 3 bits, only 3 states used)
    localparam IDLE    = 3'b001;
    localparam FOUND_1 = 3'b010;
    localparam FOUND_10= 3'b100;

    reg [2:0] state, next_state;

    // Combinational logic for next state and output
    always @(*) begin
        z = 1'b0;
        case (state)
            IDLE: begin
                if (x)
                    next_state = FOUND_1;
                else
                    next_state = IDLE;
            end
            FOUND_1: begin
                if (x)
                    next_state = FOUND_1;
                else
                    next_state = FOUND_10;
            end
            FOUND_10: begin
                if (x) begin
                    z = 1'b1;       // sequence "101" detected
                    next_state = FOUND_1; // overlap: last '1' may start new sequence
                end else begin
                    next_state = IDLE;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // State register with asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= IDLE;
        else
            state <= next_state;
    end

endmodule