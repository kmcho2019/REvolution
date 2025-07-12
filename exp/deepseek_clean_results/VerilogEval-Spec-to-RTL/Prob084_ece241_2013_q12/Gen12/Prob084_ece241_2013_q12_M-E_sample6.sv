module ShiftRegister8bitEnhanced (
    input clk,
    input enable,
    input S,
    input [7:0] parallel_in,
    input load,
    output reg [7:0] Q
);
    always @(posedge clk) begin
        if (enable) begin
            if (load)
                Q <= parallel_in;
            else
                Q <= {Q[6:0], S};
        end
    end
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
    
    // Tie parallel_in to 0 since we don't use it in this design
    ShiftRegister8bitEnhanced sr_inst (
        .clk(clk),
        .enable(enable),
        .S(S),
        .parallel_in(8'b0),
        .load(1'b0),
        .Q(Q)
    );

    // Hierarchical 8:1 mux implementation
    wire [1:0] mux_level1;
    
    // First level: Four 2:1 muxes
    assign mux_level1[0] = sel[2] ? Q[sel[1:0]+4] : Q[sel[1:0]];
    assign mux_level1[1] = sel[2] ? Q[sel[1:0]+4+2'b10] : Q[sel[1:0]+4];
    
    // Second level: Final 2:1 mux
    assign Z = sel[0] ? mux_level1[1] : mux_level1[0];
endmodule