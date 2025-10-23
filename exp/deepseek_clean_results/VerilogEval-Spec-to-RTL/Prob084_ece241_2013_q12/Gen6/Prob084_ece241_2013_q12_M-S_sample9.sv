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
    
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};  // Standard right shift
        end
    end
    
    // Simple 8:1 multiplexer
    assign Z = ({A, B, C} == 3'b000) ? Q[0] :
               ({A, B, C} == 3'b001) ? Q[1] :
               ({A, B, C} == 3'b010) ? Q[2] :
               ({A, B, C} == 3'b011) ? Q[3] :
               ({A, B, C} == 3'b100) ? Q[4] :
               ({A, B, C} == 3'b101) ? Q[5] :
               ({A, B, C} == 3'b110) ? Q[6] :
                                      Q[7];
endmodule