module ShiftRegister8bit (
    input clk,
    input enable,
    input S,
    output reg [7:0] Q
);
    // Using simple concatenation for efficient shifting
    // Clock gating would be implemented at the cell level for power optimization
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};  // MSB first shift
        end
    end
endmodule

module HierarchicalMux8to1 (
    input [7:0] data,
    input [2:0] sel,
    output out
);
    // First level: 4:1 muxes
    wire [1:0] stage1_out;
    assign stage1_out[0] = sel[1] ? (sel[0] ? data[3] : data[2]) 
                                 : (sel[0] ? data[1] : data[0]);
    assign stage1_out[1] = sel[1] ? (sel[0] ? data[7] : data[6]) 
                                 : (sel[0] ? data[5] : data[4]);
    
    // Second level: 2:1 mux
    assign out = sel[2] ? stage1_out[1] : stage1_out[0];
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
    parameter WIDTH = 8;
    
    wire [WIDTH-1:0] Q;
    wire [2:0] sel = {A, B, C};

    ShiftRegister8bit sr (
        .clk(clk),
        .enable(enable),
        .S(S),
        .Q(Q)
    );

    HierarchicalMux8to1 mux (
        .data(Q),
        .sel(sel),
        .out(Z)
    );
endmodule