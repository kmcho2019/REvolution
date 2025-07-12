module TopModule (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [2:0]  sel,
    input  wire [3:0]  data0,
    input  wire [3:0]  data1,
    input  wire [3:0]  data2,
    input  wire [3:0]  data3,
    input  wire [3:0]  data4,
    input  wire [3:0]  data5,
    output reg  [3:0]  out
);

reg [3:0] mux_out;

always @(*) begin
    case (sel)
        3'd0: mux_out = data0;
        3'd1: mux_out = data1;
        3'd2: mux_out = data2;
        3'd3: mux_out = data3;
        3'd4: mux_out = data4;
        3'd5: mux_out = data5;
        default: mux_out = 4'b0000;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        out <= 4'b0000;
    else
        out <= mux_out;
end

endmodule