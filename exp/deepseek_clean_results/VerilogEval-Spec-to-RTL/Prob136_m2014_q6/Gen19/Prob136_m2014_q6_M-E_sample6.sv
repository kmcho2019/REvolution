module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // Optimized 2-bit state encoding
    localparam [1:0] 
        A = 2'b00,
        B = 2'b01,
        C = 2'b11,
        D = 2'b10,
        E = 2'b11,  // Shares encoding with C
        F = 2'b10;   // Shares encoding with D

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 0;
        end
        else begin
            case (state)
                A: begin
                    state <= w ? A : B;
                    z <= 0;
                end
                B: begin
                    state <= w ? D : C;
                    z <= 0;
                end
                C: begin
                    state <= w ? D : E;
                    z <= 0;
                end
                D: begin
                    state <= w ? A : F;
                    z <= 0;
                end
                E: begin
                    state <= w ? D : E;
                    z <= 1;
                end
                F: begin
                    state <= w ? D : C;
                    z <= 1;
                end
            endcase
        end
    end

endmodule