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
    
    // Shift register implementation using continuous assignments
    always @(posedge clk) begin
        if (enable) begin
            Q[0] <= S;
            Q[1] <= Q[0];
            Q[2] <= Q[1];
            Q[3] <= Q[2];
            Q[4] <= Q[3];
            Q[5] <= Q[4];
            Q[6] <= Q[5];
            Q[7] <= Q[6];
        end
    end

    // 8:1 mux implemented with case statement
    assign Z = (Q & (8'b1 << {A,B,C})) != 0;
endmodule