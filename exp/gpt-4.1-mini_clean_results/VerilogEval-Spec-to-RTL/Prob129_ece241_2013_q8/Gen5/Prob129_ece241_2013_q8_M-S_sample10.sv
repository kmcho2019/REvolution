module TopModule (
    input  clk,
    input  aresetn,  // active low asynchronous reset (negative edge)
    input  x,
    output reg z
);

    // State encoding
    localparam [1:0]
        S0 = 2'b00,
        S1 = 2'b01,
        S2 = 2'b10;

    reg [1:0] current_state, next_state;

    // State register with asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Next state and output logic combined
    always @(*) begin
        z = 1'b0; // default output
        case (current_state)
            S0: begin
                if (x) next_state = S1;
                else next_state = S0;
            end
            S1: begin
                if (~x) next_state = S2;
                else next_state = S1;
            end
            S2: begin
                if (x) begin
                    next_state = S1;
                    z = 1'b1;  // sequence "101" detected here
                end
                else next_state = S0;
            end
            default: begin
                next_state = S0;
                z = 1'b0;
            end
        endcase
    end

endmodule