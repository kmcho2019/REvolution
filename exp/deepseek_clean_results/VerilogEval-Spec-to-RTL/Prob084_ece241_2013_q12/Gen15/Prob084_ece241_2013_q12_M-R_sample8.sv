module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    // 8-bit shift register implemented with explicit DFFs
    reg [7:0] Q;
    
    // Shift register logic using continuous assignments
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};  // Shift left with new bit at LSB
        end
    end

    // 8:1 mux implemented with case statement
    wire [2:0] sel = {A, B, C};
    assign Z = (sel == 3'b000) ? Q[0] :
               (sel == 3'b001) ? Q[1] :
               (sel == 3'b010) ? Q[2] :
               (sel == 3'b011) ? Q[3] :
               (sel == 3'b100) ? Q[4] :
               (sel == 3'b101) ? Q[5] :
               (sel == 3'b110) ? Q[6] :
               Q[7];  // default case for sel == 3'b111
endmodule