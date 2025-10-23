module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    parameter [2:0] A = 0, B = 1, C = 2, D = 3, E = 4, F = 5;
    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 0;
        end
        else case (state)
            A: begin state <= w ? B : A; z <= 0; end
            B: begin state <= w ? C : D; z <= 0; end
            C: begin state <= w ? E : D; z <= 0; end
            D: begin state <= w ? F : A; z <= 0; end
            E: begin state <= w ? E : D; z <= 1; end
            F: begin state <= w ? C : D; z <= 1; end
        endcase
    end

endmodule