module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

    reg [1:0] sel;
    assign sel = c[1:0];

    always @(*) begin
        case (c)
            4'd0: q = b;
            4'd1: q = e;
            4'd2: q = a;
            4'd3: q = d;
            default: q = 4'd15;  // 'f' is represented as 4'd15
        endcase
    end

    // Alternative implementation using a multiplexer
    // reg [3:0] mux_out;
    // always @(*) begin
    //     mux_out = (sel == 2'd0) ? b :
    //                (sel == 2'd1) ? e :
    //                (sel == 2'd2) ? a :
    //                (sel == 2'd3) ? d : 4'd15;
    //     q = (c < 4'd4) ? mux_out : 4'd15;
    // end

    // Clock gating to minimize unnecessary switching
    // reg clk_en;
    // always @(*) begin
    //     if (clk_en) begin
    //         // Update q only when clock is enabled
    //         q <= (c < 4'd4) ? mux_out : 4'd15;
    //     end
    // end

endmodule