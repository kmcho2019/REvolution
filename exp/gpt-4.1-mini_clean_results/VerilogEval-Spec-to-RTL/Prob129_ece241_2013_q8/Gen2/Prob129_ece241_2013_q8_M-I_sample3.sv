module TopModule (
    input  clk,
    input  aresetn,  // active low async reset
    input  x,
    output reg z
);

    // State encoding as parameters for area savings
    localparam S0 = 2'b00; // no match
    localparam S1 = 2'b01; // matched '1'
    localparam S2 = 2'b10; // matched '10'

    reg [1:0] current_state, next_state;

    // Async negative edge reset with synchronous state update
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Next state logic and output combinational logic combined with blocking assignments
    always @(*) begin
        case (current_state)
            S0: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
                z = 1'b0;
            end
            S1: begin
                if (~x)
                    next_state = S2;
                else
                    next_state = S1;
                z = 1'b0;
            end
            S2: begin
                if (x) begin
                    next_state = S1;
                    z = 1'b1; // sequence detected
                end else begin
                    next_state = S0;
                    z = 1'b0;
                end
            end
            default: begin
                next_state = S0;
                z = 1'b0;
            end
        endcase
    end

endmodule