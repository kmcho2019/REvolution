module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // Optimized 2-bit state encoding
    localparam [1:0] 
        S0 = 2'b00,  // A/B (output 0)
        S1 = 2'b01,  // C/D (output 0)
        S2 = 2'b10,  // E (output 1)
        S3 = 2'b11;  // F (output 1)

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            z <= 0;
        end
        else begin
            case (state)
                S0: begin
                    state <= w ? S0 : S1;
                    z <= 0;
                end
                S1: begin
                    state <= w ? S3 : (w ? S3 : S2);
                    z <= 0;
                end
                S2: begin
                    state <= w ? S1 : S2;
                    z <= 1;
                end
                S3: begin
                    state <= w ? S1 : (w ? S1 : S0);
                    z <= 1;
                end
            endcase
        end
    end

endmodule