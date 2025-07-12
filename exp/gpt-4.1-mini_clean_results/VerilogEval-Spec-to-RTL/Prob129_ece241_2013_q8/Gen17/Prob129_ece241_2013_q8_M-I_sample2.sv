module TopModule (
    input  clk,
    input  aresetn,  // active low asynchronous reset (negative edge)
    input  x,
    output reg z
);

    // State encoding: 3 states for sequence "101"
    localparam S0 = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b10;

    reg [1:0] state, next_state;
    reg z_next;

    // Next-state and output logic
    always @(*) begin
        z_next = 1'b0;
        case(state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S1 : S2;
            S2: begin
                if (x) begin
                    next_state = S1;
                    z_next = 1'b1;
                end else begin
                    next_state = S0;
                end
            end
            default: next_state = S0;
        endcase
    end

    // Clock enable: update state only if input or output might change
    wire clk_en = (next_state != state) || (z_next != z);

    // State register with asynchronous negative-edge reset and clock enable
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
            z <= 1'b0;
        end else if (clk_en) begin
            state <= next_state;
            z <= z_next;
        end
    end

endmodule