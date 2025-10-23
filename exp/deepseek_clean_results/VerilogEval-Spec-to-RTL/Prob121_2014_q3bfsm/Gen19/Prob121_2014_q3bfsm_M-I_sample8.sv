module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // Parameterized states for readability
    parameter [2:0] S0 = 3'b000,
                    S1 = 3'b001,
                    S2 = 3'b010,
                    S3 = 3'b011,
                    S4 = 3'b100;

    reg [2:0] state;

    // Combined state transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            z <= 1'b0;
        end
        else begin
            case (state)
                S0: state <= x ? S1 : S0;
                S1: state <= x ? S4 : S1;
                S2: state <= x ? S1 : S2;
                S3: state <= x ? S2 : S1;
                S4: state <= x ? S4 : S3;
            endcase
            
            // Registered output eliminates glitches
            z <= (state == S3) || (state == S4);
        end
    end

endmodule