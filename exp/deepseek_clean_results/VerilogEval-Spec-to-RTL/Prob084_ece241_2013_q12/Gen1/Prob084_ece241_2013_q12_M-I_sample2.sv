module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    // 8-bit shift register
    reg [7:0] Q;

    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};  // Shift left, MSB first
        end
    end

    // 3-to-8 multiplexer using case statement for better PPA
    wire [2:0] sel = {A, B, C};
    
    assign Z = (sel == 3'b000) ? Q[0] :
               (sel == 3'b001) ? Q[1] :
               (sel == 3'b010) ? Q[2] :
               (sel == 3'b011) ? Q[3] :
               (sel == 3'b100) ? Q[4] :
               (sel == 3'b101) ? Q[5] :
               (sel == 3'b110) ? Q[6] :
               Q[7];

endmodule