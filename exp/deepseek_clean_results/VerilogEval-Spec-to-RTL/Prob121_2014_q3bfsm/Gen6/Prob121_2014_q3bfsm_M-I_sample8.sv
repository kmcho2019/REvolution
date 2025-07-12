module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // One-hot state encoding
    parameter S0 = 5'b00001;
    parameter S1 = 5'b00010;
    parameter S2 = 5'b00100;
    parameter S3 = 5'b01000;
    parameter S4 = 5'b10000;

    reg [4:0] state;

    // State transitions with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            z <= 0;
        end
        else begin
            case (state)
                S0: state <= x ? S1 : S0;
                S1: state <= x ? S4 : S1;
                S2: state <= x ? S1 : S2;
                S3: state <= x ? S2 : S1;
                S4: state <= x ? S4 : S3;
                default: state <= S0;
            endcase
            
            // Registered output
            z <= (state == S3) || (state == S4);
        end
    end

endmodule