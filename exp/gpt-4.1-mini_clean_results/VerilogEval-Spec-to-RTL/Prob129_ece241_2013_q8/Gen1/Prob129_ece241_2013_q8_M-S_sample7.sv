module TopModule (
    input clk,
    input aresetn,  // active low async reset
    input x,
    output reg z
);

    // State encoding
    localparam S0 = 2'd0,
               S1 = 2'd1,
               S2 = 2'd2;

    reg [1:0] state, next_state;

    // State register with asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state and output logic (Mealy)
    always @(*) begin
        case (state)
            S0: begin
                next_state = x ? S1 : S0;
                z = 1'b0;
            end
            S1: begin
                next_state = x ? S1 : S2;
                z = 1'b0;
            end
            S2: begin
                next_state = x ? S1 : S0;
                z = x;
            end
            default: begin
                next_state = S0;
                z = 1'b0;
            end
        endcase
    end

endmodule