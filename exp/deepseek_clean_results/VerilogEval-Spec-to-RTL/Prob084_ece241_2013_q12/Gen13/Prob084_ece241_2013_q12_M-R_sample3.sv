module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    // Shift register implementation using explicit DFFs
    reg [7:0] Q;
    
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

    // 8:1 Mux implementation using case statement
    reg mux_out;
    always @(*) begin
        case ({A, B, C})
            3'b000: mux_out = Q[0];
            3'b001: mux_out = Q[1];
            3'b010: mux_out = Q[2];
            3'b011: mux_out = Q[3];
            3'b100: mux_out = Q[4];
            3'b101: mux_out = Q[5];
            3'b110: mux_out = Q[6];
            3'b111: mux_out = Q[7];
            default: mux_out = 1'b0;
        endcase
    end

    assign Z = mux_out;
endmodule