module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    reg [7:0] Q;
    wire [2:0] sel = {A, B, C};

    // Shift register implemented with continuous assignments
    wire [7:0] next_Q = enable ? {Q[6:0], S} : Q;

    // Update flip-flops
    always @(posedge clk) begin
        Q <= next_Q;
    end

    // Multiplexer implemented with case statement
    assign Z = (sel == 3'b000) ? Q[0] :
               (sel == 3'b001) ? Q[1] :
               (sel == 3'b010) ? Q[2] :
               (sel == 3'b011) ? Q[3] :
               (sel == 3'b100) ? Q[4] :
               (sel == 3'b101) ? Q[5] :
               (sel == 3'b110) ? Q[6] :
               Q[7];
endmodule