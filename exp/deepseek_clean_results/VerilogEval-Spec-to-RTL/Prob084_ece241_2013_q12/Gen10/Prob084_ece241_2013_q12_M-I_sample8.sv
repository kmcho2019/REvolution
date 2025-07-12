module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    localparam MEM_SIZE = 8;
    reg [MEM_SIZE-1:0] Q;
    wire [2:0] sel = {A, B, C};
    wire gated_clk;

    // Clock gating cell (synthesis-friendly)
    assign gated_clk = clk & enable;

    // Shift register with synchronous reset and clock gating
    always @(posedge gated_clk) begin
        Q <= {Q[MEM_SIZE-2:0], S};
    end

    // Optimized mux implementation
    assign Z = Q[sel];

    // Alternative one-hot mux implementation (commented out)
    // wire [MEM_SIZE-1:0] decoded_sel;
    // assign decoded_sel = (sel == 3'd0) ? 8'b00000001 :
    //                    (sel == 3'd1) ? 8'b00000010 :
    //                    (sel == 3'd2) ? 8'b00000100 :
    //                    (sel == 3'd3) ? 8'b00001000 :
    //                    (sel == 3'd4) ? 8'b00010000 :
    //                    (sel == 3'd5) ? 8'b00100000 :
    //                    (sel == 3'd6) ? 8'b01000000 :
    //                    8'b10000000;
    // assign Z = |(Q & decoded_sel);
endmodule