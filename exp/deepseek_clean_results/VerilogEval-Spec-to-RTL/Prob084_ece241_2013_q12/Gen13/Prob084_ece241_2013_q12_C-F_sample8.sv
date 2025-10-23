module ShiftRegister8bit (
    input clk,
    input enable,
    input S,
    output [7:0] Q
);
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (enable) begin
            // Standard shift operation (can be modified for circular shift)
            shift_reg <= {shift_reg[6:0], S};
            
            // Alternative circular shift version (uncomment to use)
            // shift_reg <= enable ? {shift_reg[6:0], S} : shift_reg;
        end
    end

    assign Q = shift_reg;
endmodule

module TreeMux8to1 (
    input [7:0] data,
    input [2:0] sel,
    output out
);
    // Tree structure for balanced timing
    wire [3:0] stage1;
    wire [1:0] stage2;
    
    assign stage1[0] = sel[0] ? data[1] : data[0];
    assign stage1[1] = sel[0] ? data[3] : data[2];
    assign stage1[2] = sel[0] ? data[5] : data[4];
    assign stage1[3] = sel[0] ? data[7] : data[6];
    
    assign stage2[0] = sel[1] ? stage1[1] : stage1[0];
    assign stage2[1] = sel[1] ? stage1[3] : stage1[2];
    
    assign out = sel[2] ? stage2[1] : stage2[0];
    
    // Alternative direct indexing (uncomment to use)
    // assign out = data[sel];
endmodule

module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    wire [7:0] Q;
    wire [2:0] sel = {A, B, C};

    ShiftRegister8bit sr (
        .clk(clk),
        .enable(enable),
        .S(S),
        .Q(Q)
    );

    TreeMux8to1 mux (
        .data(Q),
        .sel(sel),
        .out(Z)
    );
endmodule