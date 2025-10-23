module CircularShiftRegister (
    input clk,
    input enable,
    input S,
    output reg [7:0] Q
);
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};  // Standard shift operation
            // Future enhancement could use: Q <= {Q[6:0], Q[7]} for true circular shift
        end
    end
endmodule

module TreeMux8to1 (
    input [7:0] data,
    input [2:0] sel,
    output out
);
    // First level muxes
    wire mux0_out = sel[0] ? data[1] : data[0];
    wire mux1_out = sel[0] ? data[3] : data[2];
    wire mux2_out = sel[0] ? data[5] : data[4];
    wire mux3_out = sel[0] ? data[7] : data[6];
    
    // Second level muxes
    wire mux4_out = sel[1] ? mux1_out : mux0_out;
    wire mux5_out = sel[1] ? mux3_out : mux2_out;
    
    // Final level mux
    assign out = sel[2] ? mux5_out : mux4_out;
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

    CircularShiftRegister sr (
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