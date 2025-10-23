module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Optimized Gray-coded state encoding with localparam
    localparam [2:0] 
        A = 3'b000,  // z=0
        B = 3'b001,  // z=0
        C = 3'b011,  // z=0
        D = 3'b010,  // z=0
        E = 3'b110,  // z=1
        F = 3'b100;  // z=1

    reg [2:0] state;

    // Combined state transition and storage
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else begin
            case (state)
                A: state <= w ? A : B;  // A stays on 1, goes to B on 0
                B: state <= w ? D : C;  // B goes to D on 1, C on 0
                C: state <= w ? D : E;  // C goes to D on 1, E on 0
                D: state <= w ? A : F;  // D goes to A on 1, F on 0
                E: state <= w ? D : E;  // E stays on 0, goes to D on 1
                F: state <= w ? D : C;  // F goes to D on 1, C on 0
            endcase
        end
    end

    // Output is directly from state bit 2 (1 for E/F)
    assign z = state[2];

endmodule