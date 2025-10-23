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
    wire [7:0] Q;
    wire [7:0] next_Q;
    
    // Next state logic for shift register
    assign next_Q = enable ? {Q[6:0], S} : Q;
    
    // DFF instances for each bit
    dff dff0 (.clk(clk), .d(next_Q[0]), .q(Q[0]));
    dff dff1 (.clk(clk), .d(next_Q[1]), .q(Q[1]));
    dff dff2 (.clk(clk), .d(next_Q[2]), .q(Q[2]));
    dff dff3 (.clk(clk), .d(next_Q[3]), .q(Q[3]));
    dff dff4 (.clk(clk), .d(next_Q[4]), .q(Q[4]));
    dff dff5 (.clk(clk), .d(next_Q[5]), .q(Q[5]));
    dff dff6 (.clk(clk), .d(next_Q[6]), .q(Q[6]));
    dff dff7 (.clk(clk), .d(next_Q[7]), .q(Q[7]));

    // 8:1 Mux implementation using case statement
    reg mux_out;
    wire [2:0] sel = {A, B, C};
    
    always @(*) begin
        case (sel)
            3'b000: mux_out = Q[0];
            3'b001: mux_out = Q[1];
            3'b010: mux_out = Q[2];
            3'b011: mux_out = Q[3];
            3'b100: mux_out = Q[4];
            3'b101: mux_out = Q[5];
            3'b110: mux_out = Q[6];
            3'b111: mux_out = Q[7];
        endcase
    end
    
    assign Z = mux_out;
endmodule

// D flip-flop primitive
module dff (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule