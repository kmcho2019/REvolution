module CircularShiftRegister (
    input clk,
    input enable,
    input S,
    output reg [7:0] Q
);
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};  // Standard shift when enabled
            // Future expansion could make this circular: Q <= {Q[6:0], Q[7]};
        end
    end
endmodule

module DecoderMux (
    input [7:0] data,
    input [2:0] sel,
    output out
);
    wire [7:0] decoded;
    wire [7:0] and_out;
    
    // 3-to-8 decoder
    assign decoded[0] = ~sel[2] & ~sel[1] & ~sel[0];
    assign decoded[1] = ~sel[2] & ~sel[1] &  sel[0];
    assign decoded[2] = ~sel[2] &  sel[1] & ~sel[0];
    assign decoded[3] = ~sel[2] &  sel[1] &  sel[0];
    assign decoded[4] =  sel[2] & ~sel[1] & ~sel[0];
    assign decoded[5] =  sel[2] & ~sel[1] &  sel[0];
    assign decoded[6] =  sel[2] &  sel[1] & ~sel[0];
    assign decoded[7] =  sel[2] &  sel[1] &  sel[0];
    
    // AND-OR mux structure
    assign and_out[0] = decoded[0] & data[0];
    assign and_out[1] = decoded[1] & data[1];
    assign and_out[2] = decoded[2] & data[2];
    assign and_out[3] = decoded[3] & data[3];
    assign and_out[4] = decoded[4] & data[4];
    assign and_out[5] = decoded[5] & data[5];
    assign and_out[6] = decoded[6] & data[6];
    assign and_out[7] = decoded[7] & data[7];
    
    assign out = |and_out;  // OR all AND outputs
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
    
    DecoderMux mux (
        .data(Q),
        .sel(sel),
        .out(Z)
    );
endmodule