module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // State encoding: [z][state_bits]
    parameter [2:0] 
        A = 3'b000,  // z=0
        B = 3'b001,  // z=0
        C = 3'b010,  // z=0
        D = 3'b011,  // z=0
        E = 3'b110,  // z=1
        F = 3'b111;  // z=1

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 0;
        end else begin
            case (state)
                A: {z, state[1:0]} <= w ? {1'b0, 2'b01} : {1'b0, 2'b00};
                B: {z, state[1:0]} <= w ? {1'b0, 2'b10} : {1'b0, 2'b11};
                C: {z, state[1:0]} <= w ? {1'b1, 2'b10} : {1'b0, 2'b11};
                D: {z, state[1:0]} <= w ? {1'b1, 2'b11} : {1'b0, 2'b00};
                E: {z, state[1:0]} <= w ? {1'b1, 2'b10} : {1'b0, 2'b11};
                F: {z, state[1:0]} <= w ? {1'b0, 2'b10} : {1'b0, 2'b11};
            endcase
        end
    end

endmodule