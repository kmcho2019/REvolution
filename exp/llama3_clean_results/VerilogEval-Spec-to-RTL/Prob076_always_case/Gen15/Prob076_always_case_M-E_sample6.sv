// Define a basic 2-to-1 multiplexer module
module mux2to1(
    input  sel,
    input  [3:0] data0,
    input  [3:0] data1,
    output reg [3:0] out
);

always @(*) begin
    if (sel) begin
        out = data1;
    end else begin
        out = data0;
    end
end

endmodule

// Define the TopModule using the mux2to1 module
module TopModule(
    input  [2:0] sel,
    input  [3:0] data0,
    input  [3:0] data1,
    input  [3:0] data2,
    input  [3:0] data3,
    input  [3:0] data4,
    input  [3:0] data5,
    output reg [3:0] out
);

// Intermediate wires
wire [3:0] mid0, mid1;

// First level of multiplexing
mux2to1 u0(.sel(sel[0]), .data0(data0), .data1(data1), .out(mid0));
mux2to1 u1(.sel(sel[0]), .data0(data2), .data1(data3), .out(mid1));

// Second level of multiplexing
mux2to1 u2(.sel(sel[1]), .data0(mid0), .data1(mid1), .out(out));

// Third level of multiplexing (using the existing out as the final output)
// Since sel[2] determines whether to use data4 or data5, and the previous
// levels have already handled data0 through data3, we directly assign
// data4 or data5 to out based on sel[2] when sel[1:0] == 2'b11
always @(*) begin
    if (sel[1:0] == 2'b11) begin
        if (sel[2]) begin
            out = data5;
        end else begin
            out = data4;
        end
    end
end

endmodule