module CircularShiftRegister (
    input clk,
    input enable,
    input S,
    output reg [7:0] Q
);
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};  // Standard shift when enabled
        end
    end
endmodule

module Mux4to1 (
    input [3:0] data,
    input [1:0] sel,
    output reg out
);
    always @(*) begin
        case (sel)
            2'b00: out = data[0];
            2'b01: out = data[1];
            2'b10: out = data[2];
            2'b11: out = data[3];
        endcase
    end
endmodule

module Mux2to1 (
    input [1:0] data,
    input sel,
    output reg out
);
    always @(*) begin
        out = sel ? data[1] : data[0];
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
    wire [1:0] upper_sel = {A, B};
    wire lower_sel = C;
    
    // Intermediate mux outputs
    wire mux0_out, mux1_out;
    
    CircularShiftRegister sr (
        .clk(clk),
        .enable(enable),
        .S(S),
        .Q(Q)
    );
    
    // First level: Two 4:1 muxes
    Mux4to1 mux0 (
        .data(Q[3:0]),
        .sel(upper_sel),
        .out(mux0_out)
    );
    
    Mux4to1 mux1 (
        .data(Q[7:4]),
        .sel(upper_sel),
        .out(mux1_out)
    );
    
    // Second level: 2:1 mux
    Mux2to1 final_mux (
        .data({mux1_out, mux0_out}),
        .sel(lower_sel),
        .out(Z)
    );
endmodule