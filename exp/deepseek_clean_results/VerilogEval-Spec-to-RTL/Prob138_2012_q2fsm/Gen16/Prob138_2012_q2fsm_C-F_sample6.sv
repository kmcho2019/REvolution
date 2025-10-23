module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Optimized state encoding (Gray-like)
    parameter [2:0] 
        A = 3'b000,
        B = 3'b001,
        C = 3'b011,
        D = 3'b010,
        E = 3'b110,
        F = 3'b111;

    reg [2:0] state;

    // Combined state transition and storage
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end else begin
            case (state)
                A: state <= w ? B : A;
                B: state <= w ? C : D;
                C: state <= w ? E : D;
                D: state <= w ? F : A;
                E: state <= w ? E : D;
                F: state <= w ? C : D;
            endcase
        end
    end

    // Output is MSB of state (E and F have z=1)
    assign z = state[2];

endmodule