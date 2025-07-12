module TopModule (
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0]  sel,
    input         enable,  // Power gating control
    output reg [15:0] out
);

// Internal signals
reg [15:0] stage1_mux [2:0];
reg [15:0] stage2_mux;

// Hierarchical mux implementation
always @(*) begin
    // First stage: 3 groups of 3:1 muxes
    case (sel[1:0])
        2'd0: stage1_mux[0] = a;
        2'd1: stage1_mux[0] = b;
        2'd2: stage1_mux[0] = c;
        default: stage1_mux[0] = 16'hFFFF;
    endcase
    
    case (sel[1:0])
        2'd0: stage1_mux[1] = d;
        2'd1: stage1_mux[1] = e;
        2'd2: stage1_mux[1] = f;
        default: stage1_mux[1] = 16'hFFFF;
    endcase
    
    case (sel[1:0])
        2'd0: stage1_mux[2] = g;
        2'd1: stage1_mux[2] = h;
        2'd2: stage1_mux[2] = i;
        default: stage1_mux[2] = 16'hFFFF;
    endcase
    
    // Second stage: 3:1 mux
    case (sel[3:2])
        2'd0: stage2_mux = stage1_mux[0];
        2'd1: stage2_mux = stage1_mux[1];
        2'd2: stage2_mux = stage1_mux[2];
        default: stage2_mux = 16'hFFFF;
    endcase
    
    // Output with power gating
    if (enable) begin
        out = stage2_mux;
    end else begin
        out = 16'h0000;  // Power gated output
    end
end

endmodule