module TopModule (
    input [254:0] in,
    output [7:0] out
);

// Calculate the population count for each 32-bit chunk
wire [4:0] count0, count1, count2, count3, count4, count5, count6, count7;

population_count #(.WIDTH(32)) pc0 (.in(in[ 31: 0]), .out(count0));
population_count #(.WIDTH(32)) pc1 (.in(in[ 63:32]), .out(count1));
population_count #(.WIDTH(32)) pc2 (.in(in[ 95:64]), .out(count2));
population_count #(.WIDTH(32)) pc3 (.in(in[127:96]), .out(count3));
population_count #(.WIDTH(32)) pc4 (.in(in[159:128]), .out(count4));
population_count #(.WIDTH(32)) pc5 (.in(in[191:160]), .out(count5));
population_count #(.WIDTH(32)) pc6 (.in(in[223:192]), .out(count6));
population_count #(.WIDTH(7))  pc7 (.in(in[254:224]), .out(count7));

// Add up the counts from each chunk
assign out = count0 + count1 + count2 + count3 + count4 + count5 + count6 + count7;

endmodule

// Population count module
module population_count #(
    parameter WIDTH = 32
) (
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    reg [WIDTH-1:0] count;
    assign out = count;

    always @(*) begin
        count = 0;
        for (int i = 0; i < WIDTH; i++) begin
            if (in[i] == 1'b1) begin
                count = count + 1'b1;
            end
        end
    end

endmodule